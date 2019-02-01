
import Foundation



extension LEGODatabase_Connection {
    
    
    func createColorsTable() {
        
        create(table: LEGODatabase.schema.colorsTable)
    }
    
    
    func createPartsTable() {
        
        create(table: LEGODatabase.schema.partsTable)
    }
}
