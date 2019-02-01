import Foundation



/// The set of possible column types.
///
enum SQLite_ColumnType: Hashable {
    
    
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
