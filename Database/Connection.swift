
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
        
        return readAllRows(from: AppDatabaseSchema.ColorsTable()).map { values in
            
            return AppDatabaseSchema.ColorsTable.Row(
                
                name: values.first(where: { $0.column.name == AppDatabaseSchema.ColorsTable().nameColumn.name })!.value as! String,
                rgb: values.first(where: { $0.column.name == AppDatabaseSchema.ColorsTable().rgbColumn.name })!.value as! String,
                transparent: values.first(where: { $0.column.name == AppDatabaseSchema.ColorsTable().transparentColumn.name })!.value as! Bool
            )
        }
    }
    
    
    func readAllParts() -> [AppDatabaseSchema.PartsTable.Row] {
        
        return readAllRows(from: AppDatabaseSchema.PartsTable()).map { values in
            
            return AppDatabaseSchema.PartsTable.Row(
                
                name: values.first(where: { $0.column.name == AppDatabaseSchema.PartsTable().nameColumn.name })!.value as! String,
                imageURL: values.first(where: { $0.column.name == AppDatabaseSchema.PartsTable().imageURLColumn.name })!.value as! String?
            )
        }
    }
}
