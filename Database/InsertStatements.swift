
import Foundation



class ColorInsertStatement: SQLite_InsertStatement {
    
    
    init(connection: SQLite_Connection) {
        
        super.init(for: Database.schema.colorsTable, connection: connection)
    }
    
    
    func insert(name: String, rgb: String, transparent: Bool) {
        
        insert([
            
            Database.schema.colorsTable.nameColumn: name,
            Database.schema.colorsTable.rgbColumn: rgb,
            Database.schema.colorsTable.transparentColumn: transparent,
        ])
    }
}



class PartInsertStatement: SQLite_InsertStatement {

    
    init(connection: SQLite_Connection) {
        
        super.init(for: Database.schema.partsTable, connection: connection)
    }
    
    
    func insert(name: String, imageURL: String?) {
        
        insert([
            
            Database.schema.partsTable.nameColumn: name,
            Database.schema.partsTable.imageURLColumn: imageURL,
        ])
    }
}
