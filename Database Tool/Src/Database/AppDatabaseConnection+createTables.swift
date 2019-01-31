
import Foundation



extension AppDatabaseConnection {
    
    
    func createColorsTable() {
        
        create(table: Database.schema.colorsTable)
    }
    
    
    func createPartsTable() {
        
        create(table: Database.schema.partsTable)
    }
}
