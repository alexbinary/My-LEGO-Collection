
import Foundation



/// A statement that inserts LEGO colors into the SQLite database used in the
/// app to store official LEGO related data.
///
/// This class provides high-level methods that are aware of the database
/// structure.
///
class LEGODatabase_ColorInsertStatement: SQLite_InsertStatement {
    
    
    /// Creates a new statement.
    ///
    /// - Parameter connection: The connection to use to compile the query.
    ///
    init(connection: SQLite_Connection) {
        
        super.init(insertingIntoTable: LEGODatabase.schema.colorsTableDescription, connection: connection)
    }
    
    
    /// Inserts a color.
    ///
    /// - Parameter name: The color's name.
    /// - Parameter rgb: The colors's RGB representation.
    /// - Parameter transparent: Whether the colors is transparent.
    ///
    func insert(name: String, rgb: String, transparent: Bool) {
        
        let table = LEGODatabase.schema.colorsTableDescription
        
        insert([
            
            table.nameColumnDescription: name,
            table.rgbColumnDescription: rgb,
            table.transparentColumnDescription: transparent,
        ])
    }
}
