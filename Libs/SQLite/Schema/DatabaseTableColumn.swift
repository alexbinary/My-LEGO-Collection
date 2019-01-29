
import Foundation



/// A type that describes a column in a database table.
///
struct DatabaseTableColumn {
    
    
    /// The column's name.
    ///
    let name: String
    
    
    /// The column's type.
    ///
    let type: DatabaseTableColumnType
    
    
    /// Whether the column can contain the value NULL.
    ///
    let nullable: Bool
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
