
import Foundation
import SQLite3


class SQLite_Connection
{
    private var pointer: OpaquePointer!
    
    init(toDatabaseAt url: URL) {
        
        guard sqlite3_open(url.path, &pointer) == SQLITE_OK else {
            
            fatalError("[SQLite_Connection] Opening database: \(url.path). SQLite error: \(errorMessage ?? "")")
        }
    }
    
    deinit {
        
        print("[SQLite_Connection] Closing connection.")
        
        sqlite3_close(pointer)
    }
    
    private var errorMessage: String? {
        
        if let error = sqlite3_errmsg(pointer) {
            
            return String(cString: error)
            
        } else {
            
            return nil
        }
    }
    
    func compile(_ query: String) -> SQLite_Statement {
        
        var statementPointer: OpaquePointer? = nil
        
        guard sqlite3_prepare_v2(pointer, query, -1, &statementPointer, nil) == SQLITE_OK else {
            
            fatalError("[SQLite_Connection] Compiling query: \(query). SQLite error: \(errorMessage ?? "")")
        }
        
        return SQLite_Statement(pointer: statementPointer!, query: query)
    }
    
    func run(_ statement: SQLite_Statement) {
        
        guard sqlite3_step(statement.pointer) == SQLITE_DONE else {
            
            fatalError("[SQLite_Statement] Running query: \(statement.query) with bindings: \(statement.boundValues). SQLite error: \(errorMessage ?? "")")
        }
    }
    
    func run(_ statement: SQLite_Statement, with values: [Any?]) {
        
        statement.bind(values)
        
        run(statement)
    }
    
    func run(_ query: String) {
        
        let statement = compile(query)
        
        run(statement)
    }
}
