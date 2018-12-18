
import Foundation


/// A type that maps to the JSON model used by Rebrickable API endpoints to represent LEGO colors.
///
struct Rebrickable_Color: Codable {
    
    
    /// The color's user displayable name e.g. "Dark Turquoise".
    ///
    var name: String
    
    
    /// The color's RGB value in hexadecimal notation e.g. "05131D".
    ///
    var rgb: String
    
    
    /// Whether the color is transparent.
    ///
    var is_trans: Bool
}
