
import Foundation



/// A statement that reads data from a table in a SQLite database.
///
/// This class provides convenience methods that facilitate the execution of
/// queries of the form "SELECT * FROM <table>;".
///
class SQLite_SelectStatement: SQLite_Statement {
    
    
    /// The table the statement reads from.
    ///
    private let table: SQLite_Table
    
    
    /// The query that was used to compile the statement.
    ///
    private let selectQuery: SQLite_SelectQuery
    
    
    /// Creates a new statement.
    ///
    /// - Parameter table: The table the statement reads from.
    /// - Parameter connection: The connection to use to compile the query.
    ///
    init(selectingFrom table: SQLite_Table, connection: SQLite_Connection) {
        
        self.table = table
        self.selectQuery = SQLite_SelectQuery(selectingFrom: table)
        
        super.init(connection: connection, query: selectQuery)
    }
}


extension SQLite_SelectStatement {
    
    
    /// Read all result rows returned by the statement.
    ///
    /// - Returns: The rows. Values are read according to the type of the
    ///            corresponding column declared in the table description.
    ///
    func readAllRows() -> [SQLite_TableRow] {
        
        let rows = runThroughCompletion(readingResultRowsWith: table)
        
        return rows
    }
}
