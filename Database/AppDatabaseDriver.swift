
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


//    func preparePartInsertStatement() -> PartInsertStatement {
//
//
//    }
//
//
//    func readAllColors() -> [AppDatabaseSchema.ColorsTable.TableRow] {
//
//
//    }
//
//
//    func readAllParts() -> [AppDatabaseSchema.PartsTable.TableRow] {
//
//
//    }
}
