
import Foundation


extension Double {
    
    
    /// Returns this value rounded to a `Double` value with given number of decimals.
    ///
    /// This method uses the `rounded()` method internally.
    /// Refer to the documentation of that method for more info about the rounding rule used.
    ///
    /// The following example rounds the same value using two different numbers of decimals:
    /// ```
    /// (1.2345).rounded(maxNumberOfDecimals: 2)
    /// // 1.23
    /// (1.2345).rounded(maxNumberOfDecimals: 3)
    /// // 1.235
    /// ```
    ///
    /// - Parameter maxNumberOfDecimals: The maximim number of decimals digits to keep.
    ///
    /// - Returns: This value rounded to a `Double` value with given number of decimals.
    ///
    func rounded(maxNumberOfDecimals: Int) -> Double {
        
        var multi: Double = 1
        
        for _ in 1...maxNumberOfDecimals {
            multi *= 10
        }
        
        return (self * multi).rounded() / multi
    }
}
