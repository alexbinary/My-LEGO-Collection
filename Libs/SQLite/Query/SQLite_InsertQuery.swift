
import Foundation



/// A SQL query that inserts data into a SQLite database table.
///
/// This type represents queries of the form
/// `INSERT INTO <table> (<columns>) VALUES(<values>);`.
///
/// The query usually uses query parameters as placeholders for the actual
/// values. You can access the query parameters that are used in the query along
/// with the table column they correspond to with the `parameters` property.
///
struct SQLite_InsertQuery: SQLite_Query {
    
    
    /// A description of the table the query creates.
    ///
    let tableDescription: SQLite_TableDescription
    
    
    /// The query parameters used in the query.
    ///
    /// This property returns a dictionary that indicates the parameters used in
    /// the query and the table column they correspond to.
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
        
        let parameters = tableDescription.columns.map { self.parameters[$0]! }
        
        return [
            
            "INSERT INTO \(tableDescription.name) (",
            tableDescription.columns.map { $0.name } .joined(separator: ", "),
            ") VALUES(",
            parameters.map { $0.name } .joined(separator: ", "),
            ");"
            
        ].joined()
    }
}
