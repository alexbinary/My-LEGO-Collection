
import Foundation



/// A SQL query that creates a SQLite database table.
///
/// This type represents queries of the form `CREATE TABLE (<columns>);`.
///
struct SQLite_CreateTableQuery: SQLite_Query {
    
    
    /// A description of the table the query creates.
    ///
    let tableDescription: SQLite_TableDescription
    
    
    /// Creates a new query.
    ///
    /// - Parameter tableDescription: A description of the table the query
    ///             should create.
    ///
    init(creatingTable tableDescription: SQLite_TableDescription) {
     
        self.tableDescription = tableDescription
    }
    
    
    /// The SQL code that implements the query.
    ///
    var sqlRepresentation: String {
        
        return [
        
            "CREATE TABLE \(tableDescription.name) (",
            tableDescription.columns.map { $0.sqlRepresentation } .joined(separator: ", "),
            ");",
            
        ].joined()
    }
}
