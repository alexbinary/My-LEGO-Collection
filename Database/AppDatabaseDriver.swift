
import Foundation


class AppDatabaseDriver: SQLite_DatabaseDriver {
    
    
    func createColorsTable() {
        
        createTable(table: AppDatabaseSchema.ColorsTable())
    }
    
    
    func createPartsTable() {
        
        createTable(table: AppDatabaseSchema.PartsTable())
    }
    
    
    func prepareColorInsertStatement() -> ColorInsertStatement {

        return ColorInsertStatement(connection: connection)
    }


    func preparePartInsertStatement() -> PartInsertStatement {

        return PartInsertStatement(connection: connection)
    }


    func readAllColors() -> [AppDatabaseSchema.ColorsTable.TableRow] {

        return readAllRows(from: AppDatabaseSchema.ColorsTable()).map { values in
            
            return AppDatabaseSchema.ColorsTable.TableRow(
                
                name: values.first(where: { $0.column.name == AppDatabaseSchema.ColorsTable().nameColumn.name })!.value as! String,
                rgb: values.first(where: { $0.column.name == AppDatabaseSchema.ColorsTable().rgbColumn.name })!.value as! String,
                transparent: values.first(where: { $0.column.name == AppDatabaseSchema.ColorsTable().transparentColumn.name })!.value as! Bool
            )
        }
    }


    func readAllParts() -> [AppDatabaseSchema.PartsTable.TableRow] {

        return readAllRows(from: AppDatabaseSchema.PartsTable()).map { values in
            
            return AppDatabaseSchema.PartsTable.TableRow(
                
                name: values.first(where: { $0.column.name == AppDatabaseSchema.PartsTable().nameColumn.name })!.value as! String,
                imageURL: values.first(where: { $0.column.name == AppDatabaseSchema.PartsTable().imageURLColumn.name })!.value as! String?
            )
        }
    }
}
