
import Foundation



/// A type that describes a table in a database.
///
class DatabaseTable {
   
    
    /// The table's name.
    ///
    let name: String
    
    
    /// The table's columns.
    ///
    let columns: [DatabaseTableColumn]
    
    
    /// Creates a new description of a table that has the provided name and
    /// columns.
    ///
    /// - Parameter name: The table's name.
    /// - Parameter columns: The table's columns.
    ///
    init(name: String, columns: [DatabaseTableColumn]) {
        
        self.name = name
        self.columns = columns
    }
}
