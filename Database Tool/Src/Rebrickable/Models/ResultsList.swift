
import Foundation


/// A type that maps to the JSON model used by Rebrickable API endpoints that
/// return multiple results.
///
/// Rebrickable API endpoints that return multiple results use a pagination
/// system where the items are distributed on multiple pages.
///
/// Instances of this type represent a single page of results, and contain a
/// list of values of the associated type as well as meta data about the list.
///
struct Rebrickable_ResultsList<Result>: Decodable where Result: Decodable {
    
    
    /// The total number of items available across all pages.
    ///
    var count: Int
    
    
    /// The URL that clients should use to retrieve the next page of results.
    ///
    var next: URL?
    
    
    /// The items in this results list.
    ///
    var results: [Result]
}
