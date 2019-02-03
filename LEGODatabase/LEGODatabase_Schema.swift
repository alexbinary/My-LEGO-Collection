
import Foundation



/// A description of the structure of the database used in the app to store
/// official LEGO related data.
///
/// Instances of this type always have the same value.
///
struct LEGODatabase_Schema {
    
    
    /// A description of the table that stores data about the official LEGO
    /// colors.
    ///
    let colorsTable = ColorsTable()
    
    
    /// A description of the table that stores data about the official LEGO
    /// parts.
    ///
    let partsTable = PartsTable()
    
    
    /// A description of the table that stores data about the official LEGO
    /// colors.
    ///
    /// Instances of this type always have the same value.
    ///
    class ColorsTable: SQLite_TableDescription {
        
        
        /// A description of the column that stores the color's name.
        ///
        let nameColumn = SQLite_Column(
            
            name: "name",
            type: .char(size: 255),
            nullable: false
        )
        
        
        /// A description of the column that stores the color's RGB
        /// representation.
        ///
        let rgbColumn = SQLite_Column(
            
            name: "rgb",
            type: .char(size: 6),
            nullable: false
        )
        
        
        /// A description of the column that stores whether the color is
        /// transparent.
        ///
        let transparentColumn = SQLite_Column(
            
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
    
    
    /// A description of the table that stores data about the official LEGO
    /// parts.
    ///
    /// Instances of this type always have the same value.
    ///
    class PartsTable: SQLite_TableDescription {
        
        
        /// A description of the column that stores the part's name.
        ///
        let nameColumn = SQLite_Column(
            
            name: "name",
            type: .char(size: 255),
            nullable: false
        )
        
        
        /// A description of the column that stores a URL to an image that
        /// represents the part.
        ///
        let imageURLColumn = SQLite_Column(
            
            name: "image_url",
            type: .char(size: 1024),
            nullable: true
        )
        
        
        /// Creates a new instance.
        ///
        init() {
            
            super.init(name: "parts", columns: [
                
                nameColumn,
                imageURLColumn,
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
}
