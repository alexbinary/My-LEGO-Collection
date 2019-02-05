
import Foundation



/// A description of a SQLite database table.
///
class SQLite_TableDescription {
   
    
    /// The table's name.
    ///
    let name: String
    
    
    /// The table's columns.
    ///
    let columns: Set<SQLite_ColumnDescription>
    
    
    /// Creates a new description of a table.
    ///
    /// - Parameter name: The table's name.
    /// - Parameter columns: The table's columns.
    ///
    init(name: String, columns: Set<SQLite_ColumnDescription>) {
        
        self.name = name
        self.columns = columns
    }
    

    /// Returns a column from its name.
    ///
    /// - Parameter name: The column's name.
    ///
    /// - Returns: The column whose name matches the provided name, or `nil` if
    ///            the table has no column whose name matches the provided name.
    ///
    func column(withName name: String) -> SQLite_ColumnDescription? {
        
        return columns.first(where: { $0.name == name })
    }
    
    
    /// Returns whether the table has a column with a given name.
    ///
    /// - Parameter name: The column's name.
    ///
    /// - Returns: `true` if the table has a column whose name matches the
    ///            provided name, `false` otherwise.
    ///
    func hasColumn(withName name: String) -> Bool {
        
        return column(withName: name) != nil
    }
}
