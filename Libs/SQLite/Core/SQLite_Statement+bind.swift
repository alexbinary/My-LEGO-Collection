
import Foundation
import SQLite3



extension SQLite_Statement {
    
    
    func bind(_ values: [(parameterName: String, value: Any?)]) {

        sqlite3_reset(pointer)
        
        values.forEach { bind($0.value, for: $0.parameterName) }
        
        boundValues = values
    }
    

    func bind(_ value: Any?, for parameterName: String) {
        
        let int32Index = sqlite3_bind_parameter_index(pointer, parameterName)
        
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
