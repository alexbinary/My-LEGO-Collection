
import Foundation


struct DatabaseInflator {
    
    
//    /// The URL to the database file that this instance controls.
//    ///
//    private let databaseFileURL: URL
    
    
    /// The current connection to the database.
    ///
    private var connection: SQLite_Connection
    
    
    /// The executable statement for the insertion of colors.
    ///
    private var colorInsertStatement: SQLite_Statement
    
    
    /// The executable statement for insertion of parts.
    ///
    private var partInsertStatement: SQLite_Statement
    
    
    init(connection: SQLite_Connection, colorInsertStatement: SQLite_Statement, partInsertStatement: SQLite_Statement) {
        
        self.connection = connection
        self.colorInsertStatement = colorInsertStatement
        self.partInsertStatement = partInsertStatement
    }
    
    
    
    
    
    /// Inserts the provided colors in the database.
    ///
    /// You must call `prepare()` before you call this method. Inserting data
    /// without calling `prepare()` results in undefined behavior.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    func insert(_ colors: [Rebrickable_Color]) {
        
        print("[DatabaseController] Inserting \(colors.count) colors...")
        
        let insertStartTime = Date()
        
        colors.forEach { connection.run(colorInsertStatement, with: [$0.name, $0.rgb, $0.is_trans]) }
        
        print("[DatabaseController] Inserted \(colors.count) colors in \(Date().elapsedTimeSince(insertStartTime))")
    }
    
    
    /// Inserts the provided parts in the database.
    ///
    /// You must call `prepare()` before you call this method. Inserting data
    /// without calling `prepare()` results in undefined behavior.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    func insert(_ parts: [Rebrickable_Part]) {
        
        print("[DatabaseController] Inserting \(parts.count) parts...")
        
        let insertStartTime = Date()
        
        parts.forEach { connection.run(colorInsertStatement, with: [$0.name, $0.part_img_url]) }
        
        print("[DatabaseController] Inserted \(parts.count) parts in \(Date().elapsedTimeSince(insertStartTime))")
    }
}
