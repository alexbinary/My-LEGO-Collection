
import Foundation



extension SQLite_Connection {
    
    
    /// Creates a table in the database.
    ///
    /// - Parameter table: A description of the table to create.
    ///
    func create(table: DatabaseTable) {
        
        let query = SQLite_CreateTableQuery(table: table)
        
        let statement = SQLite_Statement(connection: self, query: query)
        
        statement.run()
    }
}
