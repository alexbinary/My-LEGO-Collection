
import Foundation



/// A description of the table that stores data about the official LEGO
/// parts.
///
/// Instances of this type always have the same value.
///
class LEGODatabase_PartsTableDescription: SQLite_TableDescription {
    
    
    /// A description of the column that stores the part's name.
    ///
    let nameColumnDescription = SQLite_ColumnDescription(
        
        name: "name",
        type: .char(size: 255),
        nullable: false
    )
    
    
    /// A description of the column that stores a URL to an image that
    /// represents the part.
    ///
    let imageURLColumnDescription = SQLite_ColumnDescription(
        
        name: "image_url",
        type: .char(size: 1024),
        nullable: true
    )
    
    
    /// Creates a new instance.
    ///
    init() {
        
        super.init(name: "parts", columns: [
            
            nameColumnDescription,
            imageURLColumnDescription,
            ])
    }
    
    
    /// A result row in the colors table.
    ///
    /// This type provides a type safe way to manipulate a set of value for
    /// the database parts table.
    ///
    struct Row {
        
        
        /// The part's name.
        ///
        let name: String
        
        
        /// A URL to an image that represents the part.
        ///
        let imageURL: String?
    }
}
