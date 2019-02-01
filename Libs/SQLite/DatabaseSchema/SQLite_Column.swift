
import Foundation



/// A type that describes a column in a database table.
///
struct SQLite_Column: Hashable {

    
    /// The column's name.
    ///
    let name: String
    
    
    /// The column's type.
    ///
    let type: SQLite_ColumnType
    
    
    /// Whether the column can contain the value NULL.
    ///
    let nullable: Bool
}
