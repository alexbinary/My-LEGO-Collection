
import Foundation



class LEGODatabase_ColorInsertStatement: SQLite_InsertStatement {
    
    
    init(connection: SQLite_Connection) {
        
        super.init(insertingIntoTable: LEGODatabase.schema.colorsTable, connection: connection)
    }
    
    
    func insert(name: String, rgb: String, transparent: Bool) {
        
        insert([
            
            LEGODatabase.schema.colorsTable.nameColumn: name,
            LEGODatabase.schema.colorsTable.rgbColumn: rgb,
            LEGODatabase.schema.colorsTable.transparentColumn: transparent,
        ])
    }
}
