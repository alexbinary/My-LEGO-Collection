
import Foundation


class AppDatabaseConnection: SQLite_Connection {
    
    
    func prepareColorInsertStatement() -> ColorInsertStatement {
        
        let query = insertSQLExpression(AppDatabaseSchema.ColorsTable.self)
        
        return ColorInsertStatement(query: query, connection: self)
    }
    
    
    func preparePartInsertStatement() -> PartInsertStatement {
        
        let query = insertSQLExpression(AppDatabaseSchema.PartsTable.self)
        
        return PartInsertStatement(query: query, connection: self)
    }
    
    
//    func getAllRows<TableType, TableRowType>(_ tableType: TableType.Type) -> [TableType.TableRow] where TableType: DatabaseTable, TableRowType: DatabaseTableRow {
    
//    func getAllRows<TableType>(_ tableType: TableType.Type) -> [TableType.TableRow] where TableType: DatabaseTable {
//
//        let query = ""
//
//        switch tableType {
//
//        case AppDatabaseSchema.ColorsTable:
//
//            return readResults(of: query) { (statement) in
//
//                return readColorRow(statement: statement)
//            }
//
//        case AppDatabaseSchema.PartsTable.TableRow:
//
//            return readResults(of: query) { (statement) in
//
//                return readPartRow(statement: statement)
//            }
//        }
//    }
    
    func getAllColors() -> [AppDatabaseSchema.ColorsTable.TableRow] {
        
        let query = [
            
            "SELECT * FROM",
            AppDatabaseSchema.ColorsTable.name,
            ";"
            
        ].joined(separator: " ")
        
            return readResults(of: query) { (statement) in
                
                return readColorRow(statement: statement)
            }
    }
    
    
    func getAllParts() -> [AppDatabaseSchema.PartsTable.TableRow] {
        
        let query = [
            
            "SELECT * FROM",
            AppDatabaseSchema.PartsTable.name,
            ";"
            
            ].joined(separator: " ")
        
            return readResults(of: query) { (statement) in
                
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
            imageURL:statement.readOptionalString(at: 1)
        )
    }
    
    
    func insertSQLExpression<Type>(_ type: Type.Type) -> String where Type: DatabaseTable {
        
        return [
            
            "INSERT INTO",
            type.name,
            "(\(type.columns.map { $0.name } .joined(separator: ", ")))",
            "VALUES",
            "(\(type.columns.map { _ in "?" } .joined(separator: ", ")))",
            ";"
            
        ].joined(separator: " ")
    }
}
