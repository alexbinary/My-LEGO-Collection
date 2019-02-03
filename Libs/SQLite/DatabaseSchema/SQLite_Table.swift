
import Foundation



/// A description of a SQLite database table.
///
class SQLite_Table {
   
    
    /// The table's name.
    ///
    let name: String
    
    
    /// The table's columns.
    ///
    /// - Note: The order of the columns is important for reading table rows.
    ///
    let columns: [SQLite_Column]
    
    
    init(name: String, columns: [SQLite_Column]) {
        
        self.name = name
        self.columns = columns
    }
    

    func column(withName name: String) -> SQLite_Column? {
        
        return columns.first(where: { $0.name == name })
    }
    
    
    func hasColumn(withName name: String) -> Bool {
        
        return column(withName: name) != nil
    }
}
