
import Foundation



/// A SQL query that inserts data into a table in a SQLite database.
///
/// This type represents queries of the form
/// `INSERT INTO <table> (<columns>) VALUES(<values>);`.
///
/// The query uses query parameters as placeholders for the actual values. You
/// can access the query parameters that are used in the query along with the
/// table column they correspond to with the `parameters` property.
///
struct SQLite_InsertQuery: SQLite_Query {
    
    
    /// A description of the table the query should insert data into.
    ///
    let tableDescription: SQLite_TableDescription
    
    
    /// The query parameters used in the query.
    ///
    /// This property returns a dictionary that indicates the parameter used to
    /// represent the value that should be inserted into each column.
    ///
    let parameters: [SQLite_ColumnDescription: SQLite_QueryParameter]
    
   
    /// Creates a new query.
    ///
    /// - Parameter tableDescription: A description of the table the query
    ///             should insert data into.
    ///
    init(insertingIntoTable tableDescription: SQLite_TableDescription) {
        
        self.tableDescription = tableDescription
        
        var parameters: [SQLite_ColumnDescription: SQLite_QueryParameter] = [:]
        
        for column in tableDescription.columns {
            
            parameters[column] = SQLite_QueryParameter(name: ":\(column.name)")
        }
        
        self.parameters = parameters
    }
    
    
    /// The SQL code that implements the query.
    ///
    var sqlRepresentation: String {
        
        let columns = Array(tableDescription.columns)
        let parameters = columns.map { self.parameters[$0]! }
        
        return [
            
            "INSERT INTO \(tableDescription.name) (",
            columns.map { $0.name } .joined(separator: ", "),
            ") VALUES(",
            parameters.map { $0.name } .joined(separator: ", "),
            ");"
            
        ].joined()
    }
}
