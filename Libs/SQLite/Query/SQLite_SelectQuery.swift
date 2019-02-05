
import Foundation



/// A SQL query that selects data from a table in a SQLite database.
///
/// This type represents queries of the form `SELECT * FROM <table>;`.
///
struct SQLite_SelectQuery: SQLite_Query {
    
    
    /// A description of the table the query should select data from.
    ///
    let tableDescription: SQLite_TableDescription
    
    
    /// Creates a new query.
    ///
    /// - Parameter tableDescription: The table the query should select data
    ///             from.
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
