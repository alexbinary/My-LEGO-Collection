
import Foundation



/// An object that can be represented by a SQL fragment.
///
protocol SQLite_SQLRepresentable {
    
    
    /// The SQL string that represents the object.
    ///
    var sqlRepresentation: String { get }
}

