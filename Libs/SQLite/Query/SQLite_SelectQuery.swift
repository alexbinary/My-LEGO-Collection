
import Foundation



/// A SQL query that selects data from a SQLite database table.
///
/// This type represents queries of the form `SELECT * FROM <table>;`.
///
struct SQLite_SelectQuery: SQLite_Query {
    
    
    /// A description of the table the query selects data from.
    ///
    let tableDescription: SQLite_TableDescription
    
    
    /// Creates a new query.
    ///
    /// - Parameter tableDescription: The table the query selects data from.
    ///
    init(selectingFromTable tableDescription: SQLite_TableDescription) {
        
        self.tableDescription = tableDescription
    }
    
    
    /// The SQL code that implements the query.
    ///
    var sqlRepresentation: String {
        
        return "SELECT * FROM \(tableDescription.name);"
    }
}
