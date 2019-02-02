
import Foundation



/// Set of global constants to access static data about the SQLite database used
/// in the app to store official LEGO related data.
///
struct LEGODatabase {

    
    /// A description of the database structure.
    ///
    static let schema = Schema()
    
    
    /// A description of the structure of the database used in the app to store
    /// official LEGO related data.
    ///
    /// Instances of this type always have the same value.
    ///
    struct Schema {
        
        
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
        struct ColorsTable: SQLite_Table {
            
            
            /// The table's name.
            ///
            let name = "colors"
            
            
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
            
            
            /// The table's columns.
            ///
            var columns: [SQLite_Column]
            
            
            /// Creates a new instance.
            ///
            init() {
                
                self.columns = [
                    
                    nameColumn,
                    rgbColumn,
                    transparentColumn,
                ]
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
        struct PartsTable: SQLite_Table {
            
            
            /// The table's name.
            ///
            let name = "parts"
            
            
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
            
            
            /// The table's columns.
            ///
            var columns: [SQLite_Column]
            
            
            /// Creates a new instance.
            ///
            init() {
                
                self.columns = [
                    
                    nameColumn,
                    imageURLColumn,
                ]
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
}
