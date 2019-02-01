
import Foundation



/// A SQL query that selects data from a SQLite database table.
///
/// This type represents queries of the form `SELECT * FROM <table>;`.
///
struct SQLite_SelectQuery: SQLite_Query {
    
    
    /// A description of the table the query selects data from.
    ///
    let table: SQLite_Table
    
    
    /// The SQL code that implements the query.
    ///
    var sqlRepresentation: String {
        
        return "SELECT * FROM \(table.name);"
    }
}
