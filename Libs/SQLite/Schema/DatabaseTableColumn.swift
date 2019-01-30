
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
