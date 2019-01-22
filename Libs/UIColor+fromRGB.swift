
import UIKit


extension UIColor {
    
    
    /// Creates a `UIColor` instance with red, green and blue components from an `RGB` value.
    ///
    /// This initializer calls the `UIColor.init(red:green:blue:alpha:)` initializer
    /// with the values from the `RGB` value and an alpha value of `1`.
    ///
    /// - Parameter rgb: The `RGB` value whose red, green and blue components
    ///             should be used to create the `UIColor` instance.
    ///
    convenience init(from rgb: RGB) {
        
        self.init(
            
            red: CGFloat(rgb.red),
            green: CGFloat(rgb.green),
            blue: CGFloat(rgb.blue),
            
            alpha: 1
        )
    }
}
