
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
    private(set) var boundValues: [(parameterName: String, value: Any?)] = []
    
    
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



/// A statement that inserts data into a table.
///
/// This class provides convenience methods that facilitate the execution of
/// statements that insert data into a table.
///
class InsertStatement: SQLite_Statement {
    
    
    let table: SQLite_Table
    
    
    let insertQuery: SQLite_InsertQuery
    
    
    init(for table: SQLite_Table, connection: SQLite_Connection) {
        
        self.table = table
        
        self.insertQuery = SQLite_InsertQuery(table: table)
        
        super.init(connection: connection, query: insertQuery)
    }
    
    
    func insert(_ bindings: [(column: SQLite_Column, value: Any?)]) {
        
        let values = bindings.map { binding in
            
            return (
                parameterName: insertQuery.parameters.first(where: { $0.column.name == binding.column.name })!.parameterName,
                value: binding.value
            )
        }
        
        run(with: values)
    }
}
