
import Foundation


/// A type that maps to the JSON model used by Rebrickable API endpoints to represent LEGO parts.
///
struct Rebrickable_Part: Codable {
    
    
    /// The part's user displayable name e.g. "Wedge, Plate 6 x 3 Left".
    ///
    var name: String
    
    
    /// The URL of an image that represents this part.
    ///
    var part_img_url: String?
}
