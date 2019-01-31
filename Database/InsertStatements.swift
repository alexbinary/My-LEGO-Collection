
import Foundation



class ColorInsertStatement: SQLite_InsertStatement {
    
    
    init(connection: SQLite_Connection) {
        
        super.init(for: Database.schema.colorsTable, connection: connection)
    }
    
    
    func insert(name: String, rgb: String, transparent: Bool) {
        
        insert([
            
            (column: Database.schema.colorsTable.nameColumn, value: name),
            (column: Database.schema.colorsTable.rgbColumn, value: rgb),
            (column: Database.schema.colorsTable.transparentColumn, value: transparent),
        ])
    }
}



class PartInsertStatement: SQLite_InsertStatement {

    
    init(connection: SQLite_Connection) {
        
        super.init(for: Database.schema.partsTable, connection: connection)
    }
    
    
    func insert(name: String, imageURL: String?) {
        
        insert([
            
            (column: Database.schema.partsTable.nameColumn, value: name),
            (column: Database.schema.partsTable.imageURLColumn, value: imageURL),
        ])
    }
}
