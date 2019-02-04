
import Foundation



/// A statement that creates a table in a SQLite database.
///
/// This class provides convenience methods that facilitate the execution of
/// queries of the form "CREATE TABLE (<column>);".
///
class SQLite_CreateTableStatement: SQLite_Statement {
    
    
    /// A description of the table the statement creates.
    ///
    private let tableDescription: SQLite_TableDescription
    
    
    /// The query that was used to compile the statement.
    ///
    private let createTableQuery: SQLite_CreateTableQuery
    
    
    /// Creates a new statement.
    ///
    /// - Parameter tableDescription: The table the statement should create.
    /// - Parameter connection: The connection to use to compile the query.
    ///
    init(creatingTable tableDescription: SQLite_TableDescription, connection: SQLite_Connection) {
        
        self.tableDescription = tableDescription
        self.createTableQuery = SQLite_CreateTableQuery(creatingTable: tableDescription)
        
        super.init(compiling: createTableQuery, on: connection)
    }
}


extension SQLite_CreateTableStatement {
    

    /// Executes the statement.
    ///
    func run() {
        
        _ = runThroughCompletion()
    }
}
