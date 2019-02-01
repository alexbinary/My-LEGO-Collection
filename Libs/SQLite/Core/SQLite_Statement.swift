
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
    /// statment.
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
        
        guard sqlite3_prepare_v2(connection.pointer, query.sqlString, -1, &pointer, nil) == SQLITE_OK else {
            
            fatalError("[SQLite_Statement] Preparing query: \(query.sqlString). SQLite error: \(connection.errorMessage ?? "")")
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
    

    /// Executes the statement.
    ///
    func run() {
        
        let stepResult = sqlite3_step(pointer)
        
        guard stepResult == SQLITE_DONE else {
            
            fatalError("[SQLite_Statement] sqlite3_step() returned an unexpected value: \(stepResult). Expected value was: \(SQLITE_DONE). Query: \(query.sqlString). Bound values: \(boundValues). SQLite error: \(connection.errorMessage ?? "")")
        }
    }
    
    
    /// Run the statement with values.
    ///
    /// - Parameter parameterValue: A dictionnary that indicates values to bind
    ///             that should be bound to parameters.
    ///
    func run(with parameterValues: [SQLite_QueryParameter: SQLite_QueryParameterValue]) {
        
        bind(parameterValues)
        
        run()
    }
}


extension SQLite_Statement {
    
    
    /// Bind values to the statement.
    ///
    /// - Parameter values: The values to bind to each query parameter.
    ///
    func bind(_ values: [SQLite_QueryParameter: SQLite_QueryParameterValue]) {
        
        sqlite3_reset(pointer)
        
        for (parameter, value) in values {
        
            bind(value, to: parameter)
        }
        
        boundValues = values
    }
    
    
    /// Bind a value to the statment for a specific parameter.
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
            
            fatalError("[SQLite_Statement] Trying to bind a value of unsupported type: \(String(describing: value)) to query: \(query.sqlString)")
        }
    }
}


extension SQLite_Statement {
    
    
    /// Executes a statement and reads all result rows.
    ///
    /// - Parameter tableDescription: A description of the table to use to read
    ///             the rows.
    ///
    /// - Returns: The rows.
    ///
    func readAllRows(using tableDescription: SQLite_Table) -> [SQLite_TableRow] {
        
        var rows: [SQLite_TableRow] = []
        
        while true {
            
            let stepResult = sqlite3_step(pointer)
            
            guard stepResult.isOneOf([SQLITE_ROW, SQLITE_DONE]) else {
                
                fatalError("[DatabaseController] sqlite3_step() returned \(stepResult) for query: \(query). SQLite error: \(connection.errorMessage ?? "")")
            }
            
            if stepResult == SQLITE_ROW {
                
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
    /// - Returns: The row.
    ///
    private func readRow(using tableDescription: SQLite_Table) -> SQLite_TableRow {
        
        var row = SQLite_TableRow()
        
        for (index, column) in tableDescription.columns.enumerated() {
            
            row[column] = readValue(at: index, using: column)
        }
        
        return row
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
    /// - Returns: The value.
    ///
    private func readValue(at index: Int, using columnDescription: SQLite_Column) -> SQLite_ColumnValue {
        
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
            
            fatalError("[DatabaseController] Found `NULL` while expecting non-null boolean value at index: \(index). Query: \(query.sqlString)")
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
            
            fatalError("[DatabaseController] Found `NULL` while expecting non-null string value at index: \(index). Query: \(query.sqlString)")
        }
        
        guard let raw = sqlite3_column_text(pointer, Int32(index)) else {
            
            fatalError("[DatabaseController] sqlite3_column_text() returned a nil pointer at index: \(index). Query: \(query.sqlString)")
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
