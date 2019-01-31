
import Foundation



struct SQLite_CreateTableQuery: SQLite_Query {
    
    
    let table: SQLite_Table
    
    
    var sqlString: String {
        
        return [
        
            "CREATE TABLE \(table.name) (",
            table.columns.map { SQLite_ColumnDescription(column: $0).sqlString } .joined(separator: ", "),
            ");",
            
        ].joined()
    }
}
