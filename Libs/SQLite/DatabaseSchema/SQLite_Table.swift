
import Foundation



/// A description of a SQLite database table.
///
protocol SQLite_Table {
   
    
    /// The table's name.
    ///
    var name: String { get }
    
    
    /// The table's columns.
    ///
    /// - Note: The order of the columns is important for reading table rows.
    ///
    var columns: [SQLite_Column] { get }
    

    func column(withName columnName: String) -> SQLite_Column?
}


extension SQLite_Table {
    
    
    func column(withName name: String) -> SQLite_Column? {
        
        return columns.first(where: { $0.name == name })
    }
}
