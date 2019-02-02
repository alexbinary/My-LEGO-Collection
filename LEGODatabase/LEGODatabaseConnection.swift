
import Foundation



class LEGODatabaseConnection: SQLite_Connection {
    
}


extension LEGODatabaseConnection {
    
    
    func createColorsTable() {
        
        create(LEGODatabase.schema.colorsTable)
    }
    
    
    func createPartsTable() {
        
        create(LEGODatabase.schema.partsTable)
    }
}


extension LEGODatabaseConnection {
    
    
    func prepareColorInsertStatement() -> LEGODatabaseColorInsertStatement {
        
        return LEGODatabaseColorInsertStatement(connection: self)
    }
    
    
    func preparePartInsertStatement() -> LEGODatabasePartInsertStatement {
        
        return LEGODatabasePartInsertStatement(connection: self)
    }
}


extension LEGODatabaseConnection {
    
    
    func readAllColors() -> [LEGODatabaseSchema.ColorsTable.Row] {
        
        return readAllRows(from: LEGODatabase.schema.colorsTable).map { values in
            
            return LEGODatabaseSchema.ColorsTable.Row(
                
                name: values[LEGODatabase.schema.colorsTable.nameColumn] as! String,
                rgb: values[LEGODatabase.schema.colorsTable.rgbColumn] as! String,
                transparent: values[LEGODatabase.schema.colorsTable.transparentColumn] as! Bool
            )
        }
    }
    
    
    func readAllParts() -> [LEGODatabaseSchema.PartsTable.Row] {
        
        return readAllRows(from: LEGODatabase.schema.partsTable).map { values in
            
            return LEGODatabaseSchema.PartsTable.Row(
                
                name: values[LEGODatabase.schema.partsTable.nameColumn] as! String,
                imageURL: values[LEGODatabase.schema.partsTable.imageURLColumn] as! String?
            )
        }
    }
}
