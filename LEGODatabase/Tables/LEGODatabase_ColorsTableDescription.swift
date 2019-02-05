
import Foundation



/// A description of the table that stores data about the official LEGO
/// colors.
///
/// Instances of this type always have the same value.
///
class LEGODatabase_ColorsTableDescription: SQLite_TableDescription {
    
    
    /// A description of the column that stores the color's name.
    ///
    let nameColumn = SQLite_ColumnDescription(
        
        name: "name",
        type: .char(size: 255),
        nullable: false
    )
    
    
    /// A description of the column that stores the color's RGB
    /// representation.
    ///
    let rgbColumn = SQLite_ColumnDescription(
        
        name: "rgb",
        type: .char(size: 6),
        nullable: false
    )
    
    
    /// A description of the column that stores whether the color is
    /// transparent.
    ///
    let transparentColumn = SQLite_ColumnDescription(
        
        name: "transparent",
        type: .bool,
        nullable: false
    )
    
    
    /// Creates a new instance.
    ///
    init() {
        
        super.init(name: "colors", columns: [
            
            nameColumn,
            rgbColumn,
            transparentColumn,
        ])
    }
    
    
    /// A result row in the colors table.
    ///
    /// This type provides a type safe way to manipulate a set of value for
    /// the database colors table.
    ///
    struct Row {
        
        
        /// The color's name.
        ///
        let name: String
        
        
        /// The colors's RGB representation.
        ///
        let rgb: String
        
        
        /// Whether the colors is transparent.
        ///
        let transparent: Bool
    }
}
