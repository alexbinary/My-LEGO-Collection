
import Foundation
import SQLite3



/// A prepared SQL statement.
///
/// A prepared statement is a SQL query that has been compiled into an
/// executable form. You compile a query with the `init(connection: , query:)`
/// initializer.
///
/// A statement is bound to the connection that was used to compile the query.
/// You provide the connection in the initializer.
///
/// Instances of this class hold a pointeur to the underlying statement object.
/// It is important that you let the object be deallocated when you are done to
/// destroy the statement and release associated resources.
///
class SQLite_Statement {

    
    /// The SQLite pointer to the underlying statement object.
    ///
    /// This pointer is guaranteed to always point to a valid, prepared
    /// statement.
    ///
    private var pointer: OpaquePointer!
    
    
    /// The connection the statement is bound to.
    ///
    /// A statement is bound to the connection that was used to compile the
    /// query. You provide the connection in the initializer.
    ///
    private var connection: SQLite_Connection!
    
    
    /// The SQL query that the statement was compiled from.
    ///
    /// Use this property to access the original SQL query that the statement
    /// was compiled from.
    ///
    private var query: SQLite_Query
    
    
    /// The values that have been bound to the statement's query parameters.
    ///
    /// This property stores the values that have been bound to the statement
    /// by the latest call to the `bind(parameterValues:)` method. Each call to
    /// `bind(parameterValues:)` updates theses values.
    ///
    private var boundValues: [SQLite_QueryParameter: SQLite_QueryParameterValue] = [:]
    
    
    /// Creates a new prepared statement.
    ///
    /// - Parameter query: The SQL query to compile.
    /// - Parameter connection: The connection to use to compile the query.
    ///
    init(compiling query: SQLite_Query, on connection: SQLite_Connection) {
        
        self.query = query
        self.connection = connection
        
        guard sqlite3_prepare_v2(connection.pointer, query.sqlRepresentation, -1, &pointer, nil) == SQLITE_OK else {
            
            fatalError("[SQLite_Statement] Compiling query: \(query.sqlRepresentation). SQLite error: \(connection.errorMessage ?? "")")
        }
    }
    
    
    /// Deallocates the instance.
    ///
    /// This deinitializer destroys the statement and releases associated
    /// resources.
    ///
    deinit {
        
        sqlite3_finalize(pointer)
    }
}


extension SQLite_Statement {
    

    /// Executes the statement until all result rows are returned.
    ///
    /// - Parameter parameterValues: A dictionnary that contains values to bind
    ///             to the query parameters.
    ///
    /// - Parameter tableDescription: A description of the table to use to read
    ///             the rows. You must provide a table description if the
    ///             statement returns results. If a table description is
    ///             provided, a fatal error is triggered if it does not match
    ///             the actual results.
    ///
    /// - Returns: The rows. Values are read according to the type of the
    ///            corresponding column declared in the table description.
    ///
    func runThroughCompletion(with parameterValues: [SQLite_QueryParameter: SQLite_QueryParameterValue] = [:], readingResultRowsWith tableDescription: SQLite_TableDescription? = nil) -> [SQLite_TableRow] {
        
        makeSureParameterValuesMatchActualQueryParameters(parameterValues)
        
        makeSureTableDescriptionMatchesActualResults(tableDescription)
        
        sqlite3_reset(pointer)
        
        bind(parameterValues)
        
        let rows = readAllRows(using: tableDescription)
        
        return rows
    }
    
    
    /// Checks that a set of parameter values matches the query parameters that
    /// the statement actually uses.
    ///
    /// This method triggers a fatal error if the parameter values do not match
    /// the query parameters that the statement actually uses.
    ///
    /// - Parameter parameterValues: A dictionnary that contains values to bind
    ///             to the query parameters.
    ///
    private func makeSureParameterValuesMatchActualQueryParameters(_ parameterValues: [SQLite_QueryParameter: SQLite_QueryParameterValue]) {
        
        let parameterCount = sqlite3_bind_parameter_count(pointer)
        
        guard parameterCount == parameterValues.count else {
            
            fatalError("[SQLite_Statement] Trying to bind \(parameterCount) parameter(s) to a statement that has only \(parameterCount) parameter(s). Query: \(query.sqlRepresentation) Parameter values: \(parameterValues)")
        }
        
        let parameterNames = parameterValues.keys.map { $0.name }
        
        (0..<parameterCount).forEach { index in
            
            let rawParameterName = sqlite3_bind_parameter_name(pointer, index)!
            
            let parameterName = String(cString: rawParameterName)
            
            guard parameterNames.contains(parameterName) else {
            
                fatalError("[SQLite_Statement] Statement has a query parameter \"\(parameterName)\" but no value was provided for that parameter. Query: \(query.sqlRepresentation) Parameter values: \(parameterValues)")
            }
        }
    }
        
        
    /// Checks that a table description matches the data that the statement
    /// actually returns.
    ///
    /// This method triggers a fatal error if the table description does not
    /// match the data that the statement returns.
    ///
    /// - Parameter tableDescription: The table description to evaluate.
    ///
    private func makeSureTableDescriptionMatchesActualResults(_ tableDescription: SQLite_TableDescription?) {
        
        let columnCount = sqlite3_column_count(pointer)
        
        if let tableDescription = tableDescription {
            
            if columnCount == 0 {
                
                fatalError("[SQLite_Statement] Table description provided for a query that returns no data. Query: \(query.sqlRepresentation) Table description: \(tableDescription)")
            }
            
            if columnCount != tableDescription.columns.count {
                
                fatalError("[SQLite_Statement] Actual column count (\(columnCount)) does not match table description. Query: \(query.sqlRepresentation) Table description: \(tableDescription)")
            }
            
            let columnNames = tableDescription.columnNames
            
            (0..<columnCount).forEach { index in
                
                let rawColumnName = sqlite3_column_name(pointer, index)!
                
                let columnName = String(cString: rawColumnName)
                
                if !columnNames.contains(columnName) {
                    
                    fatalError("[SQLite_Statement] Result row has a column \"\(columnName)\" but that column was not found in the provided table description. Query: \(query.sqlRepresentation) Table description: \(tableDescription)")
                }
            }
            
        } else if columnCount > 0 {
            
            fatalError("[SQLite_Statement] No table description provided for a query that returns data. Query: \(query.sqlRepresentation)")
        }
    }
}


extension SQLite_Statement {
    
    
    /// Bind values to the statement's query parameters.
    ///
    /// - Parameter parameterValues: A dictionnary that indicates values to bind
    ///             to parameters.
    ///
    private func bind(_ parameterValues: [SQLite_QueryParameter: SQLite_QueryParameterValue]) {
        
        parameterValues.forEach { (parameter, value) in
        
            bind(value, to: parameter)
        }
        
        boundValues = parameterValues
    }
    
    
    /// Bind a value to one of the statement's query parameters.
    ///
    /// - Parameter value: The value to bind.
    /// - Parameter parameter: The query parameter to bind the value to.
    ///
    private func bind(_ value: SQLite_QueryParameterValue, to parameter: SQLite_QueryParameter) {
        
        let index = sqlite3_bind_parameter_index(pointer, parameter.name)
        
        guard index != 0 else {
            
            fatalError("[SQLite_Statement] Attempted to bind parameter \"\(parameter.name)\" but the statement does not define such parameter. Query: \(query.sqlRepresentation)")
        }
        
        switch (value) {
            
        case let stringValue as String:
            
            let rawValue = NSString(string: stringValue).utf8String
            
            sqlite3_bind_text(pointer, index, rawValue, -1, nil)
            
        case let boolValue as Bool:
            
            let rawValue = Int32(exactly: NSNumber(value: boolValue))!
            
            sqlite3_bind_int(pointer, index, rawValue)
            
        case nil:
            
            sqlite3_bind_null(pointer, index)
            
        default:
            
            fatalError("[SQLite_Statement] Trying to bind a value of unsupported type: \(String(describing: value)) on query: \(query.sqlRepresentation)")
        }
    }
}


extension SQLite_Statement {
    
    
    /// Executes the statement and read each result row.
    ///
    /// - Parameter tableDescription: A description of the table to use to read
    ///             the rows. A table description must be provided if the
    ///             statement returns results.
    ///
    /// - Returns: The rows. Values are read according to the type of the
    ///            corresponding column declared in the table description.
    ///
    private func readAllRows(using tableDescription: SQLite_TableDescription?) -> [SQLite_TableRow] {
        
        var rows: [SQLite_TableRow] = []
        
        while true {
            
            let stepResult = sqlite3_step(pointer)
            
            guard stepResult.isOneOf([SQLITE_ROW, SQLITE_DONE]) else {
                
                fatalError("[SQLite_Statement] sqlite3_step() returned \(stepResult) for query: \(query.sqlRepresentation). SQLite error: \(connection.errorMessage ?? "")")
            }
            
            if stepResult == SQLITE_ROW {
                
                guard let tableDescription = tableDescription else {
                    
                    fatalError("[SQLite_Statement] The query returned result rows but no table description was provided. Query: \(query.sqlRepresentation)")
                }
                
                let row = readRow(using: tableDescription)
                
                rows.append(row)
                
            } else {
                
                break
            }
        }
        
        return rows
    }
    
    
    /// Reads a row of result from a statement.
    ///
    /// This method assumes a row of result is available for reading.
    ///
    /// - Parameter tableDescription: A description of the table to use to read
    ///             the row.
    ///
    /// - Returns: The row. Values are read according to the type of the
    ///            corresponding column declared in the table description.
    ///
    private func readRow(using tableDescription: SQLite_TableDescription) -> SQLite_TableRow {
        
        var row = SQLite_TableRow()
        
        (0..<sqlite3_column_count(pointer)).forEach { index in
            
            let rawColumnName = sqlite3_column_name(pointer, index)!
            
            let columnName = String(cString: rawColumnName)
            
            let columnDescription = tableDescription.column(withName: columnName)!
            
            row[columnDescription] = readValue(at: index, using: columnDescription)
        }
        
        return row
    }

    
    /// Reads a single value from a statement.
    ///
    /// This method assumes a row of result is available for reading.
    ///
    /// - Parameter index: The index of the value in the result row.
    ///
    /// - Parameter columnDescription: A description of the column to use to
    ///             read the value.
    ///
    /// - Returns: The value, which is read according to the type of the
    ///            column declared in the column description.
    ///
    private func readValue(at index: Int32, using columnDescription: SQLite_ColumnDescription) -> SQLite_ColumnValue {
        
        switch columnDescription.type {
            
        case .bool:
            
            return readBool(at: index)
            
        case .char:
            
            if columnDescription.nullable {
                
                return readOptionalString(at: index)
                
            } else {
                
                return readString(at: index)
            }
        }
    }
}


extension SQLite_Statement {
    
    
    /// Returns whether a value in a result row is `NULL`.
    ///
    /// This method assumes a row of result is available for reading.
    ///
    /// - Parameter index: The index of the value in the result row.
    ///
    /// - Returns: `true` if the value is `NULL`, `false` otherwise.
    ///
    private func valueIsNull(at index: Int32) -> Bool {
        
        return sqlite3_column_type(pointer, index) == SQLITE_NULL
    }
    
    
    /// Reads a boolean value from the statement, expecting a non-NULL value.
    ///
    /// This method assumes a row of result is available for reading.
    ///
    /// Triggers a fatal error if the value is `NULL`.
    ///
    /// - Parameter index: The index of the value in the result row.
    ///
    /// - Returns: The value as a boolean.
    ///
    private func readBool(at index: Int32) -> Bool {
        
        guard !valueIsNull(at: index) else {
            
            fatalError("[SQLite_Statement] Found `NULL` while expecting non-null boolean value at index: \(index). Query: \(query.sqlRepresentation)")
        }
        
        return sqlite3_column_int(pointer, index) != 0
    }
    
    
    /// Reads a string value from the statement, expecting a non-NULL value.
    ///
    /// This method assumes a row of result is available for reading.
    ///
    /// Triggers a fatal error if the value is `NULL`.
    ///
    /// - Parameter index: The index of the value in the result row.
    ///
    /// - Returns: The value as a string.
    ///
    private func readString(at index: Int32) -> String {
        
        guard !valueIsNull(at: index) else {
            
            fatalError("[SQLite_Statement] Found `NULL` while expecting non-null string value at index: \(index). Query: \(query.sqlRepresentation)")
        }
        
        guard let raw = sqlite3_column_text(pointer, index) else {
            
            fatalError("[SQLite_Statement] sqlite3_column_text() returned a nil pointer at index: \(index). Query: \(query.sqlRepresentation)")
        }
        
        return String(cString: raw)
    }
    
    
    /// Reads a string value from the statement, expecting a potentially NULL
    /// value.
    ///
    /// This method assumes a row of result is available for reading.
    ///
    /// - Parameter index: The index of the value in the result row.
    ///
    /// - Returns: The value as a string if not `NULL`, `nil` otherwise.
    ///
    private func readOptionalString(at index: Int32) -> String? {
        
        if valueIsNull(at: index) {
            
            return nil
            
        } else {
         
            return readString(at: index)
        }
    }
}
