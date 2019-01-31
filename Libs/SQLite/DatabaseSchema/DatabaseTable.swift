
import Foundation



/// A type that describes a table in a database.
///
protocol DatabaseTable {
   
    
    /// The table's name.
    ///
    var name: String { get }
    
    
    /// The table's columns.
    ///
    var columns: [DatabaseTableColumn] { get }
}
