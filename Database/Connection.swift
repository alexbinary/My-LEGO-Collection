
import Foundation



class AppDatabaseConnection: SQLite_Connection {
    
}


extension AppDatabaseConnection {
    
    
    func createColorsTable() {
        
        createTable(table: Database.schema.colorsTable)
    }
    
    
    func createPartsTable() {
        
        createTable(table: Database.schema.partsTable)
    }
}


extension AppDatabaseConnection {
    
    
    func prepareColorInsertStatement() -> ColorInsertStatement {
        
        return ColorInsertStatement(connection: self)
    }
    
    
    func preparePartInsertStatement() -> PartInsertStatement {
        
        return PartInsertStatement(connection: self)
    }
}


extension AppDatabaseConnection {
    
    
    func readAllColors() -> [AppDatabaseSchema.ColorsTable.Row] {
        
        return readAllRows(from: Database.schema.colorsTable).map { values in
            
            return AppDatabaseSchema.ColorsTable.Row(
                
                name: values.first(where: { $0.column.name == Database.schema.colorsTable.nameColumn.name })!.value as! String,
                rgb: values.first(where: { $0.column.name == Database.schema.colorsTable.rgbColumn.name })!.value as! String,
                transparent: values.first(where: { $0.column.name == Database.schema.colorsTable.transparentColumn.name })!.value as! Bool
            )
        }
    }
    
    
    func readAllParts() -> [AppDatabaseSchema.PartsTable.Row] {
        
        return readAllRows(from: Database.schema.partsTable).map { values in
            
            return AppDatabaseSchema.PartsTable.Row(
                
                name: values.first(where: { $0.column.name == Database.schema.partsTable.nameColumn.name })!.value as! String,
                imageURL: values.first(where: { $0.column.name == Database.schema.partsTable.imageURLColumn.name })!.value as! String?
            )
        }
    }
}
