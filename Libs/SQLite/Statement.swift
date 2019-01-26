
import Foundation
import SQLite3


/// A SQL query compiled into an executable form.
///
/// Use `SQLite_Connection.compile(query:)` to compile a query into a statement.
/// A statement holds a strong reference to the connection that was used to
/// produce it. It is important that you let statements be deallocated when you
/// do not use them anymore so that resources can be released.
///
/// Use the `run()` method to execute a statement. Use the `run(with:)` method
/// if your query contains parameters.
///
class SQLite_Statement {
    
    private(set) var connection: SQLite_Connection!
    
    private(set) var pointer: OpaquePointer!
    
    private(set) var query: String
    
    private(set) var boundValues: [Any?] = []
    
    init(query: String, connection: SQLite_Connection) {
        
        self.connection = connection
        self.query = query
        
        guard sqlite3_prepare_v2(connection.pointer, query, -1, &pointer, nil) == SQLITE_OK else {
            
            fatalError("[SQLite_Statement] Preparing query: \(query). SQLite error: \(connection.errorMessage ?? "")")
        }
    }
    
    deinit {
        
        sqlite3_finalize(pointer)
    }
    
    func run() {
        
        guard sqlite3_step(pointer) == SQLITE_DONE else {
            
            fatalError("[SQLite_Statement] Running query: \(query) with bindings: \(boundValues). SQLite error: \(connection.errorMessage ?? "")")
        }
    }
    
    func run(with values: [Any?]) {
        
        bind(values)
        
        run()
    }
    
    func bind(_ values: [Any?]) {
        
        sqlite3_reset(pointer)
        
        values.enumerated().forEach { bind($0.element, at: $0.offset + 1) }
        
        boundValues = values
    }
    
    func bind(_ value: Any?, at index: Int) {
        
        let int32Index = Int32(exactly: index)!
        
        switch (value) {
            
        case let stringValue as String:
            
            let rawValue = NSString(string: stringValue).utf8String
            
            sqlite3_bind_text(pointer, int32Index, rawValue, -1, nil)
            
        case let boolValue as Bool:
            
            let rawValue = Int32(exactly: NSNumber(value: boolValue))!
            
            sqlite3_bind_int(pointer, int32Index, rawValue)
            
        case nil:
            
            sqlite3_bind_null(pointer, int32Index)
            
        default:
            
            fatalError("[SQLite_Statement] Binding value: \(String(describing: value)): unsupported type.")
        }
    }
}


extension SQLite_Statement {
    
    /// Iterates over the results of a prepared statement and reads each row using the provided reader.
    ///
    /// - Parameter statement: The prepared statement to read the results of.
    /// - Parameter reader: A closure that takes the statement and returns an instance of the provided type.
    ///
    /// - Returns: One instance of the provided type for each result row.
    ///
    func readResults<ResultType>(with reader: (SQLite_Statement) -> ResultType) -> [ResultType] {
        
        var results: [ResultType] = []
        
        while true {
            
            let stepResult = sqlite3_step(pointer)
            
            guard stepResult.isOneOf([SQLITE_ROW, SQLITE_DONE]) else {
                
                fatalError("[DatabaseController] sqlite3_step() returned \(stepResult) for query: \(query). SQLite error: \(connection.errorMessage ?? "")")
            }
            
            if stepResult == SQLITE_ROW {
                
                results.append(reader(self))
                
            } else {
                
                break
            }
        }
        
        return results
    }
    
    
}


extension SQLite_Statement {
    
    /// Reads a result value from a query as a string, expecting the value cannot be `NULL`.
    ///
    /// - Parameter statement: The prepared statement to read the value from.
    /// - Parameter index: The index of the column for which the value should be returned.
    ///
    /// - Returns: The result value as a string.
    ///
    /// Terminates with a fatal error if the value is `NULL`.
    ///
    func readString(at index: Int) -> String {
        
        let value = readOptionalString(at: index)
        
        guard value != nil else {
            
            fatalError("[DatabaseController] Found NULL while expecting non null string value at index: \(index) for results of query: \(query)")
        }
        
        return value!
    }
    
    
    /// Reads a result value from a query as a string, expecting the value can be `NULL`.
    ///
    /// - Parameter statement: The prepared statement to read the value from.
    /// - Parameter index: The index of the column for which the value should be returned.
    ///
    /// - Returns: The result value as a string, or nil if the database value was `NULL`.
    ///
    func readOptionalString(at index: Int) -> String? {
        
        if let raw = sqlite3_column_text(pointer, Int32(index)) {
            
            return String(cString: raw)
            
        } else {
            
            return nil
        }
    }
    
    
    /// Reads a result value from a query as a boolean value.
    ///
    /// - Note: Reading a boolean value when the database value is `NULL` produces `false`.
    ///
    /// - Parameter statement: The prepared statement to read the value from.
    /// - Parameter index: The index of the column for which the value should be returned.
    ///
    /// - Returns: The result value as a boolean value.
    ///
    func readBool(at index: Int) -> Bool {
        
        let raw = sqlite3_column_int(pointer, Int32(index))
        
        return raw != 0
    }
}
