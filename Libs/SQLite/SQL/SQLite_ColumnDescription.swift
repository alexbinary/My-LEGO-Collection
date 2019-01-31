
import Foundation



struct SQLite_ColumnDescription: SQLite_SQLRepresentable {
    
    
    let column: SQLite_Column
    
    
    var sqlString: String {
        
        return [
            
            column.name,
            column.type.sqlString,
            column.nullable ? "NULL" : "NOT NULL",
            
        ].joined(separator: " ")
    }
}
