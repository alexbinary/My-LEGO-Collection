
import Foundation



/// A utility class that helps you create and initialize a SQLite database to
/// use as the database used in the app to store official LEGO related data.
///
struct DatabaseBuilder {
    
   
    /// Create a SQLite database and creates tables so that it can be used as
    /// the database used in the app to store official LEGO related data.
    ///
    /// - Parameter url: A URL pointing to the location where the database
    ///             should be created.
    ///
    /// - Returns: An instance of `DatabaseInflator` that you can use to insert
    ///            data into the database that was created.
    ///
    static func buildDatabase(at url: URL) -> DatabaseInflator {
        
        print("[DatabaseBuilder] Building database at \(url.path)")
        
        guard !FileManager.default.fileExists(atPath: url.path) else {

            fatalError("[DatabaseBuilder] Cannot create database, file exists: \(url.path)")
        }
        
        let connection = LEGODatabase_Connection(toDatabaseAt: url)
        
        connection.createColorsTable()
        connection.createPartsTable()
        
        return DatabaseInflator(with: connection)
    }
}
