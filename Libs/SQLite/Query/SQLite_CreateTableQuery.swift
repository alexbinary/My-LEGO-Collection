
import Foundation



/// A SQL query that creates a SQLite database table.
///
/// This type represents queries of the form `CREATE TABLE (<columns>);`.
///
struct SQLite_CreateTableQuery: SQLite_Query {
    
    
    /// A description of the table the query creates.
    ///
    let table: SQLite_Table
    
    
    /// Creates a new query.
    ///
    /// - Parameter table: A description of the table the query creates.
    ///
    init(creating table: SQLite_Table) {
     
        self.table = table
    }
    
    
    /// The SQL code that implements the query.
    ///
    var sqlRepresentation: String {
        
        return [
        
            "CREATE TABLE \(table.name) (",
            table.columns.map { $0.sqlRepresentation } .joined(separator: ", "),
            ");",
            
        ].joined()
    }
}
