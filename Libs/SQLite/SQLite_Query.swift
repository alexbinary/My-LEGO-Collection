
import Foundation



protocol SQLite_SQLRepresentable {
    
    
    var sqlString: String { get }
}



extension DatabaseTableColumnType: SQLite_SQLRepresentable {
    
    
    var sqlString: String {
        
        switch (self) {
            
        case .bool:
            
            return "BOOL"
            
        case .char(let size):
            
            return "CHAR(\(size))"
        }
    }
}



struct SQLite_ColumnDescription: SQLite_SQLRepresentable {
    
    
    let column: DatabaseTableColumn
    
    
    var sqlString: String {
        
        return [
            
            column.name,
            column.type.sqlString,
            column.nullable ? "NULL" : "NOT NULL",
            
        ].joined(separator: " ")
    }
}



protocol SQLite_Query: SQLite_SQLRepresentable {
    
}



struct SQLite_CreateTableQuery: SQLite_Query {
    
    
    let table: DatabaseTable
    
    
    var sqlString: String {
        
        return [
        
            "CREATE TABLE \(table.name) (",
            table.columns.map { SQLite_ColumnDescription(column: $0).sqlString } .joined(separator: ", "),
            ");",
            
        ].joined()
    }
}



struct SQLite_InsertQuery: SQLite_Query {
    
    
    let table: DatabaseTable
    
    
    let parameters: [(column: DatabaseTableColumn, parameterName: String)]
    
    
    init(table: DatabaseTable) {
        
        self.table = table
        
        self.parameters = table.columns.map { (column: $0, parameterName: ":\($0.name)") }
    }
    
    
    var sqlString: String {
        
        let columns: [DatabaseTableColumn] = table.columns
        let parameters = columns.map { column in
            self.parameters.first(where: { $0.column.name == column.name })!
        }
        
        return [
        
            "INSERT INTO \(table.name) (",
            columns.map { $0.name } .joined(separator: ", "),
            ") VALUES(",
            parameters.map { $0.parameterName } .joined(separator: ", "),
            ");"
            
        ].joined()
    }
}



struct SQLite_SelectQuery: SQLite_Query {
    
    
    let table: DatabaseTable
    
    
    var sqlString: String {
        
        return "SELECT * FROM \(table.name);"
    }
}
