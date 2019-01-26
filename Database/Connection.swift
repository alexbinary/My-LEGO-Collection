
import Foundation



class AppDatabaseConnection: SQLite_Connection {
}



extension AppDatabaseConnection {
    
    
    func createColorsTable() {
        
        createTable(AppDatabaseSchema.ColorsTable.self)
    }
    
    
    func createPartsTable() {
        
        createTable(AppDatabaseSchema.PartsTable.self)
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
    
    
    func getAllColors() -> [AppDatabaseSchema.ColorsTable.TableRow] {
        
        return getAllRows(AppDatabaseSchema.ColorsTable.self) { (statement) in
            
            return readColorRow(statement: statement)
        }
    }
    
    
    func getAllParts() -> [AppDatabaseSchema.PartsTable.TableRow] {
        
        return getAllRows(AppDatabaseSchema.PartsTable.self) { (statement) in
            
            return readPartRow(statement: statement)
        }
    }
    
    
    func readColorRow(statement: SQLite_Statement) -> AppDatabaseSchema.ColorsTable.TableRow {
        
        return AppDatabaseSchema.ColorsTable.TableRow(
            
            name: statement.readString(at: 0),
            rgb:statement.readString(at: 1),
            transparent: statement.readBool(at: 2)
        )
    }
    
    
    func readPartRow(statement: SQLite_Statement) -> AppDatabaseSchema.PartsTable.TableRow {
        
        return AppDatabaseSchema.PartsTable.TableRow(
            
            name: statement.readString(at: 0),
            imageURL: statement.readOptionalString(at: 1)
        )
    }
}
