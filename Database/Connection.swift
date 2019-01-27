
import Foundation



class AppDatabaseConnection: SQLite_Connection {
 
    
    
    
    func createColorsTable() {
        
        createTable(table: AppDatabaseSchema.ColorsTable())
    }
    
    
    func createPartsTable() {
        
        createTable(table: AppDatabaseSchema.PartsTable())
    }
    
    
    func prepareColorInsertStatement() -> ColorInsertStatement {
        
        return ColorInsertStatement(connection: self)
    }
    
    
    func preparePartInsertStatement() -> PartInsertStatement {
        
        return PartInsertStatement(connection: self)
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



//extension AppDatabaseConnection {
//
//
//    func createColorsTable() {
//
//        createTable(AppDatabaseSchema.ColorsTable.self)
//    }
//
//
//    func createPartsTable() {
//
//        createTable(AppDatabaseSchema.PartsTable.self)
//    }
//}
//
//
//
//extension AppDatabaseConnection {
//
//
////    func prepareColorInsertStatement() -> ColorInsertStatement {
////
////        return ColorInsertStatement(connection: self)
////    }
////
////
////
////    func preparePartInsertStatement() -> PartInsertStatement {
////
////        return PartInsertStatement(connection: self)
////    }
//}
//
//
//
//extension AppDatabaseConnection {
//
//
//    func getAllColors() -> [AppDatabaseSchema.ColorsTable.TableRow] {
//
//        return []
//
////        return getAllRows(AppDatabaseSchema.ColorsTable.self) { (statement) in
////
////            return readColorRow(statement: statement)
////        }
//    }
//
//
//    func getAllParts() -> [AppDatabaseSchema.PartsTable.TableRow] {
//
//            return []
//
////        return getAllRows(AppDatabaseSchema.PartsTable.self) { (statement) in
////            
////            return readPartRow(statement: statement)
////        }
//    }
//
//
////    func readColorRow(statement: SQLite_Statement) -> AppDatabaseSchema.ColorsTable.TableRow {
////
////        return AppDatabaseSchema.ColorsTable.TableRow(
////
////            name: statement.readString(at: 0),
////            rgb:statement.readString(at: 1),
////            transparent: statement.readBool(at: 2)
////        )
////    }
////
////
////    func readPartRow(statement: SQLite_Statement) -> AppDatabaseSchema.PartsTable.TableRow {
////
////        return AppDatabaseSchema.PartsTable.TableRow(
////
////            name: statement.readString(at: 0),
////            imageURL: statement.readOptionalString(at: 1)
////        )
////    }
//}
