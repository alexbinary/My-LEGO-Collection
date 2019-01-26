
import Foundation


class AppDatabaseConnection: SQLite_Connection {
    
    
    func prepapreColorInsertStatement() -> ColorsInsertStatement {
        
        
        let query = insertSQLExpression(AppDatabaseSchema.ColorsTable.self)
        
        return ColorsInsertStatement(query: query, connection: self)
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
