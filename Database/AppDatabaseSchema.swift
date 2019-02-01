
import Foundation



struct Database {

    
    static let schema = AppDatabaseSchema()
}



struct AppDatabaseSchema {
    
    
    let colorsTable = ColorsTable()
    
    let partsTable = PartsTable()
}


extension AppDatabaseSchema {
    
    
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
}


extension AppDatabaseSchema {
    
    
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
