
import Foundation



/// A type that describes a column in a database table.
///
class DatabaseTableColumn {
    
    
    /// The column's name.
    ///
    let name: String
    
    
    /// The column's type.
    ///
    let type: DatabaseTableColumnType
    
    
    /// Whether the column can contain the value NULL.
    ///
    let nullable: Bool
    
    
    /// Creates a new description of a column with the provided name, type, and
    /// nullability.
    ///
    /// - Parameter name: The column's name.
    /// - Parameter type: The column's type.
    /// - Parameter nullable: Whether the column can have the value NULL.
    ///
    init(name: String, type: DatabaseTableColumnType, nullable: Bool) {
        
        self.name = name
        self.type = type
        self.nullable = nullable
    }
}



/// The set of possible column types.
///
enum DatabaseTableColumnType {
   
    
    /// A column that contains a small amount of text.
    ///
    /// The associated value indicates the maximum number of characters the
    /// column can contain.
    ///
    case char(size: Int)
    
    
    /// A column that contains a boolean value.
    ///
    case bool
}
