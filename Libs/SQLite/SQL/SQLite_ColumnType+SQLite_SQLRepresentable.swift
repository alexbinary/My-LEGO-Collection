
import Foundation



extension SQLite_ColumnType: SQLite_SQLRepresentable {
    
    
    var sqlString: String {
        
        switch (self) {
            
        case .bool:
            
            return "BOOL"
            
        case .char(let size):
            
            return "CHAR(\(size))"
        }
    }
}
