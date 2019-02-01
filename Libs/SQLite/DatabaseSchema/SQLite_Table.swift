
import Foundation



/// A description of SQLite databse table.
///
protocol SQLite_Table {
   
    
    /// The table's name.
    ///
    var name: String { get }
    
    
    /// The table's columns.
    ///
    var columns: Set<SQLite_Column> { get }
}
