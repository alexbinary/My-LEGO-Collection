
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

    
    /// The SQLite pointer that represents the statement.
    ///
    /// This pointer is guaranteed to always represent a valid, prepared
    /// statement.
    ///
    private var pointer: OpaquePointer!
    
    
    /// The connection the statement is bound to.
    ///
    /// A statement is bound to the connection that was used to compile the
    /// query.
    ///
    private var connection: SQLite_Connection!
    
    
    /// The SQL query that the statement was compiled from.
    ///
    /// Use this property to access the original SQL query that the statement
    /// was compiled from.
    ///
    private var query: SQLite_Query
    
    
    /// The values that have been bound to the statement.
    ///
    /// This property stores the values that have been bound to the statement
    /// using the `bind(values:)` method. Previous bound values or replaces
    /// each time `bind(values:)` is called.
    ///
    private var boundValues: [SQLite_QueryParameter: SQLite_QueryParameterValue] = [:]
    
    
    /// Creates a new prepared statement on a given connection from a SQL query.
    ///
    /// - Parameter connection: The connection to use to compile the query.
    /// - Parameter query: The SQL query to compile.
    ///
    init(connection: SQLite_Connection, query: SQLite_Query) {
        
        self.connection = connection
        self.query = query
        
        guard sqlite3_prepare_v2(connection.pointer, query.sqlRepresentation, -1, &pointer, nil) == SQLITE_OK else {
            
            fatalError("[SQLite_Statement] Preparing query: \(query.sqlRepresentation). SQLite error: \(connection.errorMessage ?? "")")
        }
    }
    
    
    /// Deallocates the instance.
    ///
    /// This deinitializer destroys the statement.
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
    ///             the rows.
    ///
    /// - Returns: The rows. Values are read according to the type of the
    ///            corresponding column declared in the table description.
    ///
    func runThroughCompletion(with parameterValues: [SQLite_QueryParameter: SQLite_QueryParameterValue] = [:], readingResultRowsWith tableDescription: SQLite_TableDescription? = nil) -> [SQLite_TableRow] {
        
        if tableDescription != nil {
            
            crashIfTableDescriptionDoesNotMatchActualResults(tableDescription!)
        }
        
        sqlite3_reset(pointer)
        
        bind(parameterValues)
        
        let rows = readAllRows(using: tableDescription)
        
        return rows
    }
    
    
    private func readAllRows(using tableDescription: SQLite_TableDescription?) -> [SQLite_TableRow] {
        
        var rows: [SQLite_TableRow] = []
        
        while true {
            
            let stepResult = sqlite3_step(pointer)
            
            guard stepResult.isOneOf([SQLITE_ROW, SQLITE_DONE]) else {
                
                fatalError("[SQLite_Statement] sqlite3_step() returned \(stepResult) for query: \(query.sqlRepresentation). SQLite error: \(connection.errorMessage ?? "")")
            }
            
            if stepResult == SQLITE_ROW {
                
                guard tableDescription != nil else {
                    
                    fatalError("[SQLite_Statement] TODO")
                }
                
                let row = readRow(using: tableDescription!)
                
                rows.append(row)
                
            } else {
                
                break
            }
        }
        
        return rows
    }
    
    
    private func crashIfTableDescriptionDoesNotMatchActualResults(_ tableDescription: SQLite_TableDescription) {
        
        let columnCount = sqlite3_column_count(pointer)
        
        if columnCount != tableDescription.columns.count {
            
            fatalError("[SQLite_Statement] Actual column count (\(columnCount)) does not match table description: \(tableDescription). Query: \(query.sqlRepresentation)")
        }
        
        (0..<columnCount).forEach { index in
            
            let raw = sqlite3_column_name(pointer, index)!
            
            let columnName = String(cString: raw)
            
            if !tableDescription.tableHasColumn(withName: columnName) {
                
                fatalError("[SQLite_Statement] Result row has a column \"\(columnName)\" but that column was not found in the provided table description: \(tableDescription). Query: \(query.sqlRepresentation)")
            }
        }
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
            
            let raw = sqlite3_column_name(pointer, index)!
            
            let columnName = String(cString: raw)
            
            let columnDescription = tableDescription.column(withName: columnName)!
            
            row[columnDescription] = readValue(at: Int(index), using: columnDescription)
        }
        
        return row
    }
}


extension SQLite_Statement {
    
    
    /// Bind values to the statement.
    ///
    /// - Parameter parameterValues: A dictionnary that indicates values to bind
    ///             to parameters.
    ///
    func bind(_ parameterValues: [SQLite_QueryParameter: SQLite_QueryParameterValue]) {
        
        parameterValues.forEach { (parameter, value) in
        
            bind(value, to: parameter)
        }
        
        boundValues = parameterValues
    }
    
    
    /// Bind a value to the statement for a specific parameter.
    ///
    /// - Parameter value: The value to bind.
    /// - Parameter parameter: The query parameter to bind the value to.
    ///
    func bind(_ value: SQLite_QueryParameterValue, to parameter: SQLite_QueryParameter) {
        
        let index = sqlite3_bind_parameter_index(pointer, parameter.name)
        
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
            
            fatalError("[SQLite_Statement] Trying to bind a value of unsupported type: \(String(describing: value)) to query: \(query.sqlRepresentation)")
        }
    }
}


extension SQLite_Statement {
    
    
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
    private func readValue(at index: Int, using columnDescription: SQLite_ColumnDescription) -> SQLite_ColumnValue {
        
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
    private func valueIsNull(at index: Int) -> Bool {
        
        return sqlite3_column_type(pointer, Int32(index)) == SQLITE_NULL
    }
    
    
    /// Reads a boolean value from the statement, expecting a non-NULL value.
    ///
    /// This method assumes a row of result is available for reading.
    ///
    /// This method triggers a fatal error if the value is `NULL`.
    ///
    /// - Parameter index: The index of the value in the result row.
    ///
    /// - Returns: The value as a boolean.
    ///
    private func readBool(at index: Int) -> Bool {
        
        guard !valueIsNull(at: index) else {
            
            fatalError("[SQLite_Statement] Found `NULL` while expecting non-null boolean value at index: \(index). Query: \(query.sqlRepresentation)")
        }
        
        return sqlite3_column_int(pointer, Int32(index)) != 0
    }
    
    
    /// Reads a string value from the statement, expecting a non-NULL value.
    ///
    /// This method assumes a row of result is available for reading.
    ///
    /// This method triggers a fatal error if the value is `NULL`.
    ///
    /// - Parameter index: The index of the value in the result row.
    ///
    /// - Returns: The value as a string.
    ///
    private func readString(at index: Int) -> String {
        
        guard !valueIsNull(at: index) else {
            
            fatalError("[SQLite_Statement] Found `NULL` while expecting non-null string value at index: \(index). Query: \(query.sqlRepresentation)")
        }
        
        guard let raw = sqlite3_column_text(pointer, Int32(index)) else {
            
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
    private func readOptionalString(at index: Int) -> String? {
        
        if valueIsNull(at: index) {
            
            return nil
            
        } else {
         
            return readString(at: index)
        }
    }
}
