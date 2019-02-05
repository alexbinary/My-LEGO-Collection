
import Foundation



/// A connection to the SQLite database used in the app to store official LEGO
/// related data.
///
/// You open a connection with the `init(toDatabaseAt:)` initializer, passing
/// the path to the SQLite database file you want to open.
///
/// This class provides high-level methods that are aware of the database
/// structure.
///
/// Instances of this class hold a pointer to the underlying connection object.
/// It is important that you let the object be deallocated when you are done to
/// close the connection and release associated resources.
///
class LEGODatabase_Connection: SQLite_Connection {
    
}


extension LEGODatabase_Connection {
    
    
    /// Creates the table that stores data about the official LEGO colors.
    ///
    func createColorsTable() {
        
        createTable(describedBy: LEGODatabase.schema.colorsTableDescription)
    }
    
    
    /// Creates the table that stores data about the official LEGO parts.
    ///
    func createPartsTable() {
        
        createTable(describedBy: LEGODatabase.schema.partsTableDescription)
    }
}


extension LEGODatabase_Connection {
    
    
    /// Prepares a query that inserts colors into the database.
    ///
    /// - Returns: A prepared statement that inserts colors into the database.
    ///
    func prepareColorInsertStatement() -> LEGODatabase_ColorInsertStatement {
        
        return LEGODatabase_ColorInsertStatement(connection: self)
    }
    
    
    /// Prepares a query that inserts parts into the database.
    ///
    /// - Returns: A prepared statement that inserts parts into the database.
    ///
    func preparePartInsertStatement() -> LEGODatabase_PartInsertStatement {
        
        return LEGODatabase_PartInsertStatement(connection: self)
    }
}


extension LEGODatabase_Connection {
    
    
    /// Reads all colors in the database.
    ///
    /// - Returns: An array that contains all the rows in the table that stores
    ///            the colors.
    ///
    func readAllColors() -> [LEGODatabase_ColorsTableDescription.Row] {
        
        return readAllRows(fromTable: LEGODatabase.schema.colorsTableDescription).map { columnValues in
            
            return LEGODatabase_ColorsTableDescription.Row(
                
                name: columnValues[LEGODatabase.schema.colorsTableDescription.nameColumn] as! String,
                rgb: columnValues[LEGODatabase.schema.colorsTableDescription.rgbColumn] as! String,
                transparent: columnValues[LEGODatabase.schema.colorsTableDescription.transparentColumn] as! Bool
            )
        }
    }
    
    
    /// Reads all parts in the database.
    ///
    /// - Returns: An array that contains all the rows in the table that stores
    ///            the parts.
    ///
    func readAllParts() -> [LEGODatabase_PartsTableDescription.Row] {
        
        return readAllRows(fromTable: LEGODatabase.schema.partsTableDescription).map { columnValues in
            
            return LEGODatabase_PartsTableDescription.Row(
                
                name: columnValues[LEGODatabase.schema.partsTableDescription.nameColumn] as! String,
                imageURL: columnValues[LEGODatabase.schema.partsTableDescription.imageURLColumn] as! String?
            )
        }
    }
}
