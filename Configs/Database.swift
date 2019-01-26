
import Foundation



/// Contains information about the database used in the app.
///
struct Database {
    
    
    /// The schema of the database used in the app.
    ///
    static let schema = AppDatabaseSchema()
}



/// Schema of the database used in the app.
///
class AppDatabaseSchema: DatabaseSchema {
    
    
    //    /// Table for the LEGO colors.
    //    ///
    //    let colorsTable = ColorsTable()
    //
    //
    //    /// Table for the LEGO parts.
    //    ///
    ////    let partsTable: PartsTable
    //
    //
    //    /// Creates a new instance of the database schema.
    //    ///
    //    init() {
    //
    //        colorsTable = ColorsTable()
    ////        partsTable = PartsTable()
    //
    ////        super.init(tables: [
    ////
    ////            colorsTable,
    //////            partsTable,
    ////        ])
    //    }
}

extension AppDatabaseSchema {
    
    
    
    
    /// Table for the LEGO colors.
    ///
    class ColorsTable: DatabaseTable {
        
        
        static let name = "colors"
        
        
        static var columns: [DatabaseTableColumn] = [
            
            nameColumn,
            rgbColumn,
            transparentColumn,
            ]
        
        
        /// Column for the color's name.
        ///
        static let nameColumn = DatabaseTableColumn(
            
            name: "name",
            type: .char(size: 255),
            nullable: false
        )
        
        
        /// Column for the color's rgb value.
        ///
        static let rgbColumn = DatabaseTableColumn(
            
            name: "rgb",
            type: .char(size: 6),
            nullable: false
        )
        
        
        /// Column that indicates whether the color is transparent.
        ///
        static let transparentColumn = DatabaseTableColumn(
            
            name: "transparent",
            type: .bool,
            nullable: false
        )
        
        
        typealias TableRow = Row
        
        struct Row {
            
            let name: String
            
            let rgb: String
            
            let transparent: Bool
        }
    }
}




///// Table for the LEGO parts.
/////
//class PartsTable: DatabaseTable {
//
//
//    /// Column for the part's name.
//    ///
//    let nameColumn: DatabaseTableColumn
//
//
//    /// Column for a URL to an image of the part.
//    ///
//    let imageURLColumn: DatabaseTableColumn
//
//
//    /// Creates a new instance of the table schema.
//    ///
//    init() {
//
//        nameColumn = DatabaseTableColumn(name: "name", type: .char(size: 255), nullable: false)
//        imageURLColumn = DatabaseTableColumn(name: "image_url", type: .char(size: 1024), nullable: true)
//
//        super.init(name: "parts", columns: [
//
//            nameColumn,
//            imageURLColumn,
//        ])
//    }
//}
//
//
//struct PartsTableRow: DatabaseTableRow {
//
//
//    let name: String
//
//    let imageURL: String?
//}
