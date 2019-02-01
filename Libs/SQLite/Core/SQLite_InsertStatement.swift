
import Foundation



/// A statement that inserts data into a table.
///
/// This class provides convenience methods that facilitate the execution of
/// statements that insert data into a table.
///
class SQLite_InsertStatement: SQLite_Statement {
    
    
    let table: SQLite_Table
    
    
    let insertQuery: SQLite_InsertQuery
    
    
    init(for table: SQLite_Table, connection: SQLite_Connection) {
        
        self.table = table
        
        self.insertQuery = SQLite_InsertQuery(table: table)
        
        super.init(connection: connection, query: insertQuery)
    }
    
    
    func insert(_ bindings: [SQLite_Column: SQLite_QueryParameterValue]) {
        
        var values: [SQLite_QueryParameter: SQLite_QueryParameterValue] = [:]
        
        for (column, value) in bindings {
        
            let parameter = insertQuery.parameters[column]!

            values[parameter] = value
        }
        
        run(with: values)
    }
}
