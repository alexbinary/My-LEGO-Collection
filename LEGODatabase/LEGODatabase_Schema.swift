
import Foundation



/// Set of global constants to access static data about the SQLite database used
/// in the app to store official LEGO related data.
///
struct LEGODatabase {

    
    /// A description of the database structure.
    ///
    static let schema = LEGODatabase_Schema()
}



/// A description of the structure of the database used in the app to store
/// official LEGO related data.
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
    class ColorsTable: SQLite_Table {
        
        
        let name = "colors"
        
        
        lazy var columns: Set<SQLite_Column> = [
            
            nameColumn,
            rgbColumn,
            transparentColumn,
        ]
        
        
        let nameColumn = SQLite_Column(
            
            name: "name",
            type: .char(size: 255),
            nullable: false
        )
        
        
        let rgbColumn = SQLite_Column(
            
            name: "rgb",
            type: .char(size: 6),
            nullable: false
        )
        
        
        let transparentColumn = SQLite_Column(
            
            name: "transparent",
            type: .bool,
            nullable: false
        )
        
        
        struct Row {
            
            let name: String
            
            let rgb: String
            
            let transparent: Bool
        }
    }
    
    
    /// A description of the table that stores data about the official LEGO
    /// parts.
    ///
    class PartsTable: SQLite_Table {
        
        
        let name = "parts"
        
        
        lazy var columns: Set<SQLite_Column> = [
            
            nameColumn,
            imageURLColumn,
        ]
        
        
        let nameColumn = SQLite_Column(
            
            name: "name",
            type: .char(size: 255),
            nullable: false
        )
        
        
        let imageURLColumn = SQLite_Column(
            
            name: "image_url",
            type: .char(size: 1024),
            nullable: true
        )
        
        
        struct Row {
            
            let name: String
            
            let imageURL: String?
        }
    }
}
