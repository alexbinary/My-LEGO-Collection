
import Foundation



class LEGODatabase_ColorInsertStatement: SQLite_InsertStatement {
    
    
    init(connection: SQLite_Connection) {
        
        super.init(insertingIntoTable: LEGODatabase.schema.colorsTableDescription, connection: connection)
    }
    
    
    func insert(name: String, rgb: String, transparent: Bool) {
        
        let table = LEGODatabase.schema.colorsTableDescription
        
        insert([
            
            table.nameColumnDescription: name,
            table.rgbColumnDescription: rgb,
            table.transparentColumnDescription: transparent,
        ])
    }
}
