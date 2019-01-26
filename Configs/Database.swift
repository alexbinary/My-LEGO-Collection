
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
    
    
    /// Table for the LEGO colors.
    ///
    let colorsTable: ColorsTable
    
    
    /// Table for the LEGO parts.
    ///
    let partsTable: PartsTable
    
    
    /// Creates a new instance of the database schema.
    ///
    init() {
        
        colorsTable = ColorsTable()
        partsTable = PartsTable()
        
        super.init(tables: [
            
            colorsTable,
            partsTable,
        ])
    }
}



/// Table for the LEGO colors.
///
class ColorsTable: DatabaseTable {
   
    
    /// Column for the color's name.
    ///
    let nameColumn: DatabaseTableColumn
    
    
    /// Column for the color's rgb value.
    ///
    let rgbColumn: DatabaseTableColumn
    
    
    /// Column that indicates whether the color is transparent.
    ///
    let transparentColumn: DatabaseTableColumn
    
    
    /// Creates a new instance of the table schema.
    ///
    init() {
        
        nameColumn = DatabaseTableColumn(name: "name", type: .char(size: 255), nullable: false)
        rgbColumn = DatabaseTableColumn(name: "rgb", type: .char(size: 6), nullable: false)
        transparentColumn = DatabaseTableColumn(name: "transparent", type: .bool, nullable: false)
        
        super.init(name: "colors", columns: [
            
            nameColumn,
            rgbColumn,
            transparentColumn,
        ])
    }
}



/// Table for the LEGO parts.
///
class PartsTable: DatabaseTable {
    
    
    /// Column for the part's name.
    ///
    let nameColumn: DatabaseTableColumn
    
    
    /// Column for a URL to an image of the part.
    ///
    let imageURLColumn: DatabaseTableColumn
    
    
    /// Creates a new instance of the table schema.
    ///
    init() {
        
        nameColumn = DatabaseTableColumn(name: "name", type: .char(size: 255), nullable: false)
        imageURLColumn = DatabaseTableColumn(name: "image_url", type: .char(size: 1024), nullable: true)
        
        super.init(name: "parts", columns: [
            
            nameColumn,
            imageURLColumn,
        ])
    }
}
