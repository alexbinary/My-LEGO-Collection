
import Foundation



class LEGODatabase_ColorInsertStatement: SQLite_InsertStatement {
    
    
    init(connection: SQLite_Connection) {
        
        super.init(insertingIntoTable: LEGODatabase.schema.colorsTableDescription, connection: connection)
    }
    
    
    func insert(name: String, rgb: String, transparent: Bool) {
        
        insert([
            
            LEGODatabase.schema.colorsTableDescription.nameColumn: name,
            LEGODatabase.schema.colorsTableDescription.rgbColumn: rgb,
            LEGODatabase.schema.colorsTableDescription.transparentColumn: transparent,
        ])
    }
}
