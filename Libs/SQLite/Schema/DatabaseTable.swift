
import Foundation



/// A type that describes a table in a database.
///
protocol DatabaseTable {
    
    
//    associatedtype TableRow: DatabaseTableRow
   
    
    /// The table's name.
    ///
    var name: String { get }
    
    
    /// The table's columns.
    ///
    var columns: [DatabaseTableColumn] { get }
//
//    
//    /// Creates a new description of a table that has the provided name and
//    /// columns.
//    ///
//    /// - Parameter name: The table's name.
//    /// - Parameter columns: The table's columns.
//    ///
//    init(name: String, columns: [DatabaseTableColumn]) {
//        
//        self.name = name
//        self.columns = columns
//    }
}
