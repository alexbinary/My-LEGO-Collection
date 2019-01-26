
import Foundation
import SQLite3


class SQLite_Connection
{
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
    
    var errorMessage: String? {
        
        if let error = sqlite3_errmsg(pointer) {
            
            return String(cString: error)
            
        } else {
            
            return nil
        }
    }
    
    func compile(_ query: String) -> SQLite_Statement {
        
        return SQLite_Statement(query: query, connection: self)
    }
    
    func run(_ query: String) {
        
        let statement = compile(query)
        
        statement.run()
    }
    
    /// Iterates over the results of a query and reads each row using the provided reader.
    ///
    /// - Parameter query: The SQL query to read the results of.
    /// - Parameter reader: A closure that takes the statement and returns an instance of the provided type.
    ///
    /// - Returns: One instance of the provided type for each result row.
    ///
    func readResults<ResultType>(of query: String, with reader: (SQLite_Statement) -> ResultType) -> [ResultType] {
        
        let statement = compile(query)
        
        let results = statement.readResults(with: reader)
        
        return results
    }
}
