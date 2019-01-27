
import Foundation



protocol SQLite_SQLRepresentable {
    
    
    var sql: String { get }
}



struct SQLite_ColumnTypeDescription: SQLite_SQLRepresentable {
    
    
    let type: DatabaseTableColumnType
    
    
    var sql: String {
        
        switch (type) {
            
        case .bool:
            
            return "BOOL"
            
        case .char(let size):
            
            return "CHAR(\(size))"
        }
    }
}



struct SQLite_ColumnDescription: SQLite_SQLRepresentable {
    
    
    let column: DatabaseTableColumn
    
    
    var sql: String {
        
        return [
            
            column.name,
            SQLite_ColumnTypeDescription(type: column.type).sql,
            column.nullable ? "NULL" : "NOT NULL",
            
        ].joined(separator: " ")
    }
}



protocol SQLite_Query: SQLite_SQLRepresentable {
    
}



struct SQLite_CreateTableQuery: SQLite_Query {
    
    
    let table: DatabaseTable
    
    
    var sql: String {
        
        return [
        
            "CREATE TABLE \(table.name) (",
            table.columns.map { SQLite_ColumnDescription(column: $0).sql } .joined(separator: ", "),
            ");",
            
        ].joined()
    }
}



struct SQLite_InsertQuery: SQLite_Query {
    
    
    let table: DatabaseTable
    
    
    var sql: String {
        
        return [
        
            "INSERT INTO \(table.name) (",
            table.columns.map { $0.name } .joined(separator: ", "),
            ") VALUES(",
            table.columns.map { _ in "?" } .joined(separator: ", "),
            ");"
            
        ].joined()
    }
}



struct SQLite_SelectQuery: SQLite_Query {
    
    
    let table: DatabaseTable
    
    
    var sql: String {
        
        return "SELECT * FROM \(table.name);"
    }
}
