
import Foundation



/// A statement that inserts LEGO parts into the SQLite database used in the app
/// to store official LEGO related data.
///
/// This class provides high-level methods that are aware of the database
/// structure.
///
class LEGODatabase_PartInsertStatement: SQLite_InsertStatement {

    
    /// Creates a new statement.
    ///
    /// - Parameter connection: The connection to use to compile the query.
    ///
    init(connection: SQLite_Connection) {
        
        super.init(insertingIntoTable: LEGODatabase.schema.partsTableDescription, connection: connection)
    }
    
    
    /// Inserts a part.
    ///
    /// - Parameter name: The part's name.
    /// - Parameter imageURL: The URL of an image that represents the part.
    ///
    func insert(name: String, imageURL: String?) {
        
        let table = LEGODatabase.schema.partsTableDescription
        
        insert([
            
            table.nameColumnDescription: name,
            table.imageURLColumnDescription: imageURL,
        ])
    }
}
