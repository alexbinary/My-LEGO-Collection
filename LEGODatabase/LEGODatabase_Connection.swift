
import Foundation



class LEGODatabase_Connection: SQLite_Connection {
    
}


extension LEGODatabase_Connection {
    
    
    func createColorsTable() {
        
        create(table: LEGODatabase.schema.colorsTable)
    }
    
    
    func createPartsTable() {
        
        create(table: LEGODatabase.schema.partsTable)
    }
}


extension LEGODatabase_Connection {
    
    
    func prepareColorInsertStatement() -> ColorInsert_Statement {
        
        return ColorInsert_Statement(connection: self)
    }
    
    
    func preparePartInsertStatement() -> PartInsertStatement {
        
        return PartInsertStatement(connection: self)
    }
}


extension LEGODatabase_Connection {
    
    
    func readAllColors() -> [LEGODatabase_Schema.ColorsTable.Row] {
        
        return readAllRows(from: LEGODatabase.schema.colorsTable).map { values in
            
            return LEGODatabase_Schema.ColorsTable.Row(
                
                name: values[LEGODatabase.schema.colorsTable.nameColumn] as! String,
                rgb: values[LEGODatabase.schema.colorsTable.rgbColumn] as! String,
                transparent: values[LEGODatabase.schema.colorsTable.transparentColumn] as! Bool
            )
        }
    }
    
    
    func readAllParts() -> [LEGODatabase_Schema.PartsTable.Row] {
        
        return readAllRows(from: LEGODatabase.schema.partsTable).map { values in
            
            return LEGODatabase_Schema.PartsTable.Row(
                
                name: values[LEGODatabase.schema.partsTable.nameColumn] as! String,
                imageURL: values[LEGODatabase.schema.partsTable.imageURLColumn] as! String?
            )
        }
    }
}
