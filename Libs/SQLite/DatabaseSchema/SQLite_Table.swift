
import Foundation



/// A type that describes a table in a database.
///
protocol SQLite_Table {
   
    
    /// The table's name.
    ///
    var name: String { get }
    
    
    /// The table's columns.
    ///
    var columns: [SQLite_Column] { get }
}
