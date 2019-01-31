
import Foundation



struct SQLite_InsertQuery: SQLite_Query {
    
    
    let table: SQLite_Table
    
    
    let parameters: [(column: SQLite_Column, parameterName: String)]
    
    
    init(table: SQLite_Table) {
        
        self.table = table
        
        self.parameters = table.columns.map { (column: $0, parameterName: ":\($0.name)") }
    }
    
    
    var sqlString: String {
        
        let columns: [SQLite_Column] = table.columns
        let parameters = columns.map { column in
            self.parameters.first(where: { $0.column.name == column.name })!
        }
        
        return [
            
            "INSERT INTO \(table.name) (",
            columns.map { $0.name } .joined(separator: ", "),
            ") VALUES(",
            parameters.map { $0.parameterName } .joined(separator: ", "),
            ");"
            
        ].joined()
    }
}
