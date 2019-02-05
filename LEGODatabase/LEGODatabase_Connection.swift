
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
        
        createTable(describedBy: LEGODatabase.schema.colorsTable)
    }
    
    
    /// Creates the table that stores data about the official LEGO parts.
    ///
    func createPartsTable() {
        
        createTable(describedBy: LEGODatabase.schema.partsTable)
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
    
    
    /// Read all colors in the database.
    ///
    /// - Returns: An array of rows from the table that stores the colors.
    ///
    func readAllColors() -> [LEGODatabase_ColorsTableDescription.Row] {
        
        return readAllRows(fromTable: LEGODatabase.schema.colorsTable).map { values in
            
            return LEGODatabase_ColorsTableDescription.Row(
                
                name: values[LEGODatabase.schema.colorsTable.nameColumn] as! String,
                rgb: values[LEGODatabase.schema.colorsTable.rgbColumn] as! String,
                transparent: values[LEGODatabase.schema.colorsTable.transparentColumn] as! Bool
            )
        }
    }
    
    
    /// Read all parts in the database.
    ///
    /// - Returns: An array of rows from the table that stores the parts.
    ///
    func readAllParts() -> [LEGODatabase_PartsTableDescription.Row] {
        
        return readAllRows(fromTable: LEGODatabase.schema.partsTable).map { values in
            
            return LEGODatabase_PartsTableDescription.Row(
                
                name: values[LEGODatabase.schema.partsTable.nameColumn] as! String,
                imageURL: values[LEGODatabase.schema.partsTable.imageURLColumn] as! String?
            )
        }
    }
}
