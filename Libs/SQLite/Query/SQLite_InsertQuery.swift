
import Foundation



struct SQLite_InsertQuery: SQLite_Query {
    
    
    let table: SQLite_Table
    
    
    let parameters: [SQLite_Column: SQLite_QueryParameter]
    
    
    init(for table: SQLite_Table) {
        
        self.table = table
        
        var parameters: [SQLite_Column: SQLite_QueryParameter] = [:]
        
        for column in table.columns {
            
            parameters[column] = SQLite_QueryParameter(name: ":\(column.name)")
        }
        
        self.parameters = parameters
    }
    
    
    var sqlString: String {
        
        let columns: [SQLite_Column] = table.columns
        let parameters = columns.map { self.parameters[$0]! }
        
        return [
            
            "INSERT INTO \(table.name) (",
            columns.map { $0.name } .joined(separator: ", "),
            ") VALUES(",
            parameters.map { $0.name } .joined(separator: ", "),
            ");"
            
        ].joined()
    }
}
