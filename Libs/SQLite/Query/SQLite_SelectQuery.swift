
import Foundation



struct SQLite_SelectQuery: SQLite_Query {
    
    
    let table: SQLite_Table
    
    
    var sqlString: String {
        
        return "SELECT * FROM \(table.name);"
    }
}
