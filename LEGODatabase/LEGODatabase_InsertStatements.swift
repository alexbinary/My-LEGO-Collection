
import Foundation



class ColorInsert_Statement: SQLite_InsertStatement {
    
    
    init(connection: SQLite_Connection) {
        
        super.init(for: LEGODatabase.schema.colorsTable, connection: connection)
    }
    
    
    func insert(name: String, rgb: String, transparent: Bool) {
        
        insert([
            
            LEGODatabase.schema.colorsTable.nameColumn: name,
            LEGODatabase.schema.colorsTable.rgbColumn: rgb,
            LEGODatabase.schema.colorsTable.transparentColumn: transparent,
        ])
    }
}



class PartInsertStatement: SQLite_InsertStatement {

    
    init(connection: SQLite_Connection) {
        
        super.init(for: LEGODatabase.schema.partsTable, connection: connection)
    }
    
    
    func insert(name: String, imageURL: String?) {
        
        insert([
            
            LEGODatabase.schema.partsTable.nameColumn: name,
            LEGODatabase.schema.partsTable.imageURLColumn: imageURL,
        ])
    }
}
