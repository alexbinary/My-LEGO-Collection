
import Foundation


/// A type that stores values for red, green and blue components of a color.
///
/// Use this type when you need a lightweight and type-safe way to store colors
/// without relying on UI frameworks like `UIKit` or `CoreGraphics`.
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
    
    
    /// Declaring a convenience initializer in an extension keeps the
    /// automatically-generated memberwize initializer.
    /// https://www.hackingwithswift.com/example-code/language/how-to-add-a-custom-initializer-to-a-struct-without-losing-its-memberwise-initializer
    
    
    /// Creates a new instance from a 6-digit hexadecimal representation e.g. "A0D8F4".
    ///
    /// This initializer expects the input string to be a valid hexadecimal
    /// representation of a number with exactly six digits, and terminates with
    /// a fatal error if this is not the case.
    ///
    /// Example of valid values: `fe4e57`, `FE4E57`, `748990`
    /// Example of invalid values: `0xfe4e57`, `eee`, `brown`
    ///
    init(fromHexString string: String) {
        
        guard string.count == 6 else {
            
            fatalError("Extracting RGB values from hexadecimal representation: invalid input: \"\(string)\". Input must be exactly 6 character long. Expected something like \"A0D8F4\".")
        }
        
        guard let number = Int(string, radix: 16) else {
            
            fatalError("Extracting RGB values from hexadecimal representation: invalid input: \"\(string)\". Expected something like \"A0D8F4\".")
        }
        
        self.r = Float((number & 0xFF0000) >> 16) / 255.0
        self.g = Float((number & 0x00FF00) >>  8) / 255.0
        self.b = Float((number & 0x0000FF) >>  0) / 255.0
    }
}
