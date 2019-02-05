
import Foundation



/// A description of the structure of the SQLite database used in the app to
/// store official LEGO related data.
///
/// Instances of this type always have the same value.
///
struct LEGODatabase_Schema {
    
    
    /// A description of the table that stores data about the official LEGO
    /// colors.
    ///
    let colorsTableDescription = LEGODatabase_ColorsTableDescription()
    
    
    /// A description of the table that stores data about the official LEGO
    /// parts.
    ///
    let partsTableDescription = LEGODatabase_PartsTableDescription()
}
