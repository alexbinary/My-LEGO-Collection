
import Foundation
import SQLite3



class SQLite_Connection {
    
    
    private(set) var pointer: OpaquePointer!

    
    init(toDatabaseAt url: URL) {
        
        guard sqlite3_open(url.path, &pointer) == SQLITE_OK else {
            
            fatalError("[SQLite_Connection] Opening database: \(url.path). SQLite error: \(errorMessage ?? "")")
        }
    }
    
    
    deinit {
        
        print("[SQLite_Connection] Closing connection.")
        
        sqlite3_close(pointer)
    }
}


extension SQLite_Connection {
    
    
    var errorMessage: String? {
        
        if let error = sqlite3_errmsg(pointer) {
            
            return String(cString: error)
            
        } else {
            
            return nil
        }
    }
}


extension SQLite_Connection {
    
    
    func createTable(table: DatabaseTable) {
        
        let query = SQLite_CreateTableQuery(table: table)
        
        let statement = SQLite_Statement(connection: self, query: query)
        
        statement.run()
    }
    
    
    func readAllRows(from table: DatabaseTable) -> [[(column: DatabaseTableColumn, value: Any?)]] {
        
        let query = SQLite_SelectQuery(table: table)
        
        let statement = SQLite_Statement(connection: self, query: query)
        
        return statement.readResults() { statement in
            
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
