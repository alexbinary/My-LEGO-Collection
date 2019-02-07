
import Foundation



/// An object that you can use to read data from the database used in the app to
/// store official LEGO related data.
///
/// It is important that you let the object be deallocated when you are done
/// to close the connection to the database and release associated resources.
///
struct DatabaseReader {
    
    
    /// The connection to the SQLite database.
    ///
    private var connection: LEGODatabase_Connection
    
    
    /// Creates a new reader.
    ///
    /// - Parameter url: A URL to the database that the reader should read from.
    ///
    init(forDatabaseAt url: URL) {
        
        print("[DatabaseReader] Opening connection to \(url.path)")
        
        self.connection = LEGODatabase_Connection(toDatabaseAt: url)
    }
    
    
    /// Reads all the colors in the database.
    ///
    /// - Returns: An array that contains all the colors that exist in the
    ///            database. Ordering is not guaranteed.
    ///
    func readAllColors() -> [LEGO_Color] {
        
        print("[DatabaseReader] Fetching all colors")
        
        let startDate = Date()
 
        let colors = connection.readAllColors().map { tableRow in color(from: tableRow) }
        
        print("[DatabaseController] Fetched \(colors.count) colors in \(Date().elapsedTimeSince(startDate))")
        
        return colors
    }
    
    
    /// Reads all the parts in the database.
    ///
    /// - Returns: An array that contains all the parts that exist in the
    ///            database. Ordering is not guaranteed.
    ///
    func readAllParts() -> [LEGO_Part] {
        
        print("[DatabaseReader] Fetching all parts")
        
        let startDate = Date()
        
        let parts = connection.readAllParts().map { tableRow in part(from: tableRow) }
        
        print("[DatabaseController] Fetched \(parts.count) parts in \(Date().elapsedTimeSince(startDate))")
        
        return parts
    }
}


extension DatabaseReader {
    
    
    /// Creates an instance of `LEGO_Color` from a database table row.
    ///
    /// - Parameter tableRow: A database table row that corresponds to a color.
    ///
    /// - Returns: An instance of `LEGO_Color` created from the values in the
    ///            table row.
    ///
    func color(from tableRow: LEGODatabase_ColorsTableDescription.Row) -> LEGO_Color {
        
        let name = tableRow.name
        let rgb = RGB(fromHexString: tableRow.rgb)
        let transparent = tableRow.transparent
        
        return LEGO_Color(
            
            name: name,
            rgb: rgb,
            transparent: transparent
        )
    }
    
    
    /// Creates an instance of `LEGO_Part` from a database table row.
    ///
    /// - Parameter tableRow: A database table row that corresponds to a part.
    ///
    /// - Returns: An instance of `LEGO_Part` created from the values in the
    ///            table row.
    ///
    private func part(from tableRow: LEGODatabase_PartsTableDescription.Row) -> LEGO_Part {
        
        let name = tableRow.name
        let imageURL = tableRow.imageURL != nil ? URL(string: tableRow.imageURL!) : nil
        
        return LEGO_Part(
            
            name: name,
            imageURL: imageURL
        )
    }
}
