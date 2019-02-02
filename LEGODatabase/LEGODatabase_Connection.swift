
import Foundation



class LEGODatabase_Connection: SQLite_Connection {
    
}


extension LEGODatabase_Connection {
    
    
    func createColorsTable() {
        
        create(LEGODatabase.schema.colorsTable)
    }
    
    
    func createPartsTable() {
        
        create(LEGODatabase.schema.partsTable)
    }
}


extension LEGODatabase_Connection {
    
    
    func prepareColorInsertStatement() -> LEGODatabase_ColorInsertStatement {
        
        return LEGODatabase_ColorInsertStatement(connection: self)
    }
    
    
    func preparePartInsertStatement() -> LEGODatabase_PartInsertStatement {
        
        return LEGODatabase_PartInsertStatement(connection: self)
    }
}


extension LEGODatabase_Connection {
    
    
    func readAllColors() -> [LEGODatabase.Schema.ColorsTable.Row] {
        
        return readAllRows(from: LEGODatabase.schema.colorsTable).map { values in
            
            return LEGODatabase.Schema.ColorsTable.Row(
                
                name: values[LEGODatabase.schema.colorsTable.nameColumn] as! String,
                rgb: values[LEGODatabase.schema.colorsTable.rgbColumn] as! String,
                transparent: values[LEGODatabase.schema.colorsTable.transparentColumn] as! Bool
            )
        }
    }
    
    
    func readAllParts() -> [LEGODatabase.Schema.PartsTable.Row] {
        
        return readAllRows(from: LEGODatabase.schema.partsTable).map { values in
            
            return LEGODatabase.Schema.PartsTable.Row(
                
                name: values[LEGODatabase.schema.partsTable.nameColumn] as! String,
                imageURL: values[LEGODatabase.schema.partsTable.imageURLColumn] as! String?
            )
        }
    }
}
