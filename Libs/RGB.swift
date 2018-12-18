
import Foundation


/// A type that stores values for red, green and blue components of a color.
///
/// Use this type when you need a lightweight and type-safe way to store colors
/// without relying on UI frameworks like UIKit or CoreGraphics.
///
struct RGB {
    
    
    /// The red component, specified as a value from 0.0 to 1.0.
    ///
    let r: Float
    
    
    /// The green component, specified as a value from 0.0 to 1.0.
    ///
    let g: Float
    
    
    /// The blue component, specified as a value from 0.0 to 1.0.
    ///
    let b: Float
}


extension RGB {
    
    
    /// Creates a new instance from a hexadecimal representation e.g. "A0D8F4".
    ///
    /// This initializer nevers fails, but terminates with a fatal error if the
    /// input string is not a valid hexadecimal representation of a triplet of
    /// numbers.
    ///
    init(fromHexString string: String) {
        
        guard let number = Int(string, radix: 16) else {
            
            fatalError("Extracting RGB values from hexadecimal representation: invalid input: \"\(string)\". Expected something like \"A0D8F4\".")
        }

        self.r = Float((number & 0xFF0000) >> 16) / 255.0
        self.g = Float((number & 0x00FF00) >>  8) / 255.0
        self.b = Float((number & 0x0000FF) >>  0) / 255.0
    }
}
