
import Foundation



extension AppDatabaseConnection {
    
    
    func readAllColors() -> [AppDatabaseSchema.ColorsTable.Row] {
        
        return readAllRows(from: Database.schema.colorsTable).map { values in
            
            return AppDatabaseSchema.ColorsTable.Row(
                
                name: values[Database.schema.colorsTable.nameColumn] as! String,
                rgb: values[Database.schema.colorsTable.rgbColumn] as! String,
                transparent: values[Database.schema.colorsTable.transparentColumn] as! Bool
            )
        }
    }
    
    
    func readAllParts() -> [AppDatabaseSchema.PartsTable.Row] {
        
        return readAllRows(from: Database.schema.partsTable).map { values in
            
            return AppDatabaseSchema.PartsTable.Row(
                
                name: values[Database.schema.partsTable.nameColumn] as! String,
                imageURL: values[Database.schema.partsTable.imageURLColumn] as! String?
            )
        }
    }
}
