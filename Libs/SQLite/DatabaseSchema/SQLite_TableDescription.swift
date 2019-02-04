
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
    
    
    init(name: String, columns: Set<SQLite_ColumnDescription>) {
        
        self.name = name
        self.columns = columns
    }
    

    func column(withName name: String) -> SQLite_ColumnDescription? {
        
        return columns.first(where: { $0.name == name })
    }
    
    
    func tableHasColumn(withName name: String) -> Bool {
        
        return column(withName: name) != nil
    }
}
