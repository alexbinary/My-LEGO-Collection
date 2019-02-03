
import Foundation



/// A statement that creates a table in a SQLite database.
///
/// This class provides convenience methods that facilitate the execution of
/// "CREATE TABLE" statements.
///
class SQLite_CreateTableStatement: SQLite_Statement {
    
    
    /// The table the statement creates.
    ///
    private let table: SQLite_Table
    
    
    /// The query that was used to compile the statement.
    ///
    private let createTableQuery: SQLite_CreateTableQuery
    
    
    /// Creates a new statement for a given table.
    ///
    /// - Parameter table: The table the statement should insert data into.
    /// - Parameter connection: The connection to use to compile the query.
    ///
    init(creating table: SQLite_Table, connection: SQLite_Connection) {
        
        self.table = table
        self.createTableQuery = SQLite_CreateTableQuery(creating: table)
        
        super.init(connection: connection, query: createTableQuery)
    }
}


extension SQLite_CreateTableStatement {
    

    /// Executes the statement.
    ///
    func run() {
        
        _ = runThroughCompletion()
    }
}
