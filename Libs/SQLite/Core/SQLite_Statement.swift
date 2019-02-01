
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
    private(set) var pointer: OpaquePointer!
    
    
    /// The connection the statement is bound to.
    ///
    /// A statement is bound to the connection that was used to compile the
    /// query.
    ///
    private(set) var connection: SQLite_Connection!
    
    
    /// The SQL query that the statement was compiled from.
    ///
    /// Use this property to access the original SQL query that the statement
    /// was compiled from.
    ///
    private(set) var query: SQLite_Query
    
    
    /// The values that have been bound to the statement.
    ///
    /// This property stores the values that have been bound to the statement
    /// using the `bind(values:)` method. Previous bound values or replaces
    /// each time `bind(values:)` is called.
    ///
    private(set) var boundValues: [SQLite_QueryParameter: SQLite_QueryParameterValue] = [:]
    
    
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