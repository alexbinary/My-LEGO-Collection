
import Foundation



class AppDatabaseSchema: DatabaseSchema {
    
    
    
    class ColorsTable: DatabaseTable {
        
        
        let name = "colors"
        
        
        lazy var columns: [DatabaseTableColumn] = [
            
            nameColumn,
            rgbColumn,
            transparentColumn,
        ]
        
        
        let nameColumn = DatabaseTableColumn(
            
            name: "name",
            type: .char(size: 255),
            nullable: false
        )
        
        
        let rgbColumn = DatabaseTableColumn(
            
            name: "rgb",
            type: .char(size: 6),
            nullable: false
        )
        
        
        let transparentColumn = DatabaseTableColumn(
            
            name: "transparent",
            type: .bool,
            nullable: false
        )
        
        
        struct TableRow: DatabaseTableRow {
            
            let name: String
            
            let rgb: String
            
            let transparent: Bool
            
//            lazy var bindings: [Any?] = [
//             
//                name, rgb, transparent
//            ]
        }
    }
    
    
    
    class PartsTable: DatabaseTable {
        
        
        let name = "parts"
        
        
        lazy var columns: [DatabaseTableColumn] = [
            
            nameColumn,
            imageURLColumn,
        ]
        
        
        let nameColumn = DatabaseTableColumn(
            
            name: "name",
            type: .char(size: 255),
            nullable: false
        )
        
        
        let imageURLColumn = DatabaseTableColumn(
            
            name: "image_url",
            type: .char(size: 1024),
            nullable: true
        )
        
        
        struct TableRow: DatabaseTableRow {
            
            
            let name: String
            
            let imageURL: String?
            
//            lazy var bindings: [Any?] = [
//                
//                name, imageURL
//            ]
        }
    }
}
