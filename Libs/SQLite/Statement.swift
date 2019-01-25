
import Foundation
import SQLite3


class SQLite_Statement {
    
    private(set) var pointer: OpaquePointer!
    
    private(set) var query: String
    
    private(set) var boundValues: [Any?] = []
    
    init(pointer: OpaquePointer, query: String) {
        
        self.pointer = pointer
        self.query = query
    }
    
    deinit {
        
        sqlite3_finalize(pointer)
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
