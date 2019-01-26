
import Foundation



/// A type that describes a database.
///
class DatabaseSchema {
    
    
    /// The tables in the database.
    ///
    let tables: [DatabaseTable]
    
    
    /// Creates a new schema that describes a database with the provided tables.
    ///
    /// - Parameter tables: The tables in the database described by this schema.
    ///
    init(tables: [DatabaseTable]) {
        
        self.tables = tables
    }
}
