
import Foundation



struct SQLite_DatabaseDriver {
    
    
    let connection: SQLite_Connection
    
    
    func createTable(table: DatabaseTable) {
        
        let query = SQLite_CreateTableQuery(table: table)
        
        connection.run(query)
    }
    
    
    func insert(_ values: [Any?], into table: DatabaseTable) {
        
        let query = SQLite_InsertQuery(table: table)
        
        connection.run(query, with: values)
    }
    
    
    func prepareInsert(for table: DatabaseTable) -> InsertStatement {
        
        let query = SQLite_InsertQuery(table: table)
        
        return InsertStatement(connection: connection, query: query)
    }
    
    
    func readAllRows(from table: DatabaseTable) -> [[(column: DatabaseTableColumn, value: Any?)]] {
        
        let query = SQLite_SelectQuery(table: table).sql
        
        return connection.readResults(of: query) { statement in
            
            table.columns.enumerated().map { (index, column) in
                
                switch column.type {
                    
                case .bool:
                    
                    if column.nullable {
                    
                        fatalError("unsupported column type")
                        
                    } else {
                        
                        return (column: column, value: statement.readBool(at: index) as Any?)
                    }
                    
                case .char:
                    
                    if column.nullable {
                        
                        return (column: column, value: statement.readOptionalString(at: index))
                        
                    } else {
                        
                        return (column: column, value: statement.readString(at: index))
                    }
                }
            }
        }
    }
}
