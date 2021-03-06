
import Foundation


extension Date {
    
    
    /// Returns a string that represents the amount of time between this value and the provided date.
    ///
    /// The amount of time is expressed either in seconds or milliseconds, depending on the value.
    /// Example results: "3.4s", "56ms"
    ///
    /// - Parameter date: The date to measure the elapsed time since.
    ///
    /// - Returns: A string that represents the amount of time between this instance and the provided date,
    ///            expressed either in seconds or milliseconds.
    ///
    func elapsedTimeSince(_ date: Date) -> String {
    
        var number = self.timeIntervalSince(date)
        var unit: timeUnit = .seconds
        
        if number < 1 {
            
            number *= 1000
            unit = .milliseconds
        }
        
        return "\(number.rounded(maxNumberOfDecimals: 2))\(unit.rawValue)"
    }
    
    
    /// Units of time measurement.
    ///
    /// Raw values are the string representation of each unit.
    ///
    enum timeUnit: String {
        
        case seconds = "s"
        case milliseconds = "ms"
    }
}
