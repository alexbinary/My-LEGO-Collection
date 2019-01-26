
import UIKit


extension UIColor {
    
    
    /// Creates a `UIColor` instance that represents a LEGO color.
    ///
    /// This initializer uses the `rgb` property of the provided `LEGO_Color` instance
    /// to create a `UIColor` with the corresponding red, green and blue components.
    ///
    /// - Parameter legoColor: The instance of `LEGO_Color` that should be used
    ///             to create the `UIColor` instance.
    ///
    convenience init(from legoColor: LEGO_Color) {
        
        self.init(from: legoColor.rgb)
    }
}

