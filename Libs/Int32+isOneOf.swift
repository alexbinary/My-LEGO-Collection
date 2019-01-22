
import Foundation


extension Int32 {
    
    
    /// Returns whether this value is in the provided array.
    ///
    /// - Parameter values: Array of values to compare to.
    ///
    /// - Returns: Whether the value is in the array.
    ///
    func isOneOf(_ values: [Int32]) -> Bool {
        
        return values.contains(self)
    }
}
