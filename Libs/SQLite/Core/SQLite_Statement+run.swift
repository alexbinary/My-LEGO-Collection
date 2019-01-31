
import Foundation
import SQLite3



extension SQLite_Statement {
    
    
    func run() {
        
        guard sqlite3_step(pointer) == SQLITE_DONE else {
            
            fatalError("[SQLite_Statement] Running query: \(query) with bindings: \(boundValues). SQLite error: \(connection.errorMessage ?? "")")
        }
    }
    
    
    func run(with values: [(parameterName: String, value: Any?)]) {
    
        bind(values)
        
        run()
    }
}
