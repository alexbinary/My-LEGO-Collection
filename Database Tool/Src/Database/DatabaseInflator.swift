
import Foundation



/// An object that you can use to insert data from the Rebrickable web service
/// into the database used in the app to store official LEGO related data.
///
/// Instances of this class are initialized on a connection to a specific
/// database. You obtain an instance of this class with the
/// `DatabaseBuilder.buildDatabase(at:)` method.
///
/// It is important that you let the object be deallocated when you are done
/// to close the connection to the database and release associated resources.
///
struct DatabaseInflator {
    

    /// The prepared statement that should be used to insert colors into the
    /// database.
    ///
    private var colorInsertStatement: LEGODatabase_ColorInsertStatement
    
    
    /// The prepared statement that should be used to insert parts into the
    /// database.
    ///
    private var partInsertStatement: LEGODatabase_PartInsertStatement
    
    
    /// Creates a new inflator.
    ///
    /// - Parameter connection: The connection to the database that this inflator
    ///             should insert data into.
    ///
    init(with connection: LEGODatabase_Connection) {
        
        self.colorInsertStatement = connection.prepareColorInsertStatement()
        self.partInsertStatement = connection.preparePartInsertStatement()
    }
    
    
    /// Inserts a set of LEGO colors from the Rebrickable web service.
    ///
    /// - Parameter colors: A set of colors from the Rebrickable web service
    ///             that should be inserted into the database.
    ///
    func insert(_ colors: [Rebrickable_Color]) {
        
        print("[DatabaseInflator] Inserting \(colors.count) colors...")
        
        let insertStartTime = Date()
        
        colors.forEach { color in
            
            colorInsertStatement.insert(name: color.name, rgb: color.rgb, transparent: color.is_trans)
        }
        
        print("[DatabaseInflator] Inserted \(colors.count) colors in \(Date().elapsedTimeSince(insertStartTime))")
    }
    
    
    /// Inserts a set of LEGO parts from the Rebrickable web service.
    ///
    /// - Parameter parts: A set of parts from the Rebrickable web service that
    ///             should be inserted into the database.
    ///
    func insert(_ parts: [Rebrickable_Part]) {
        
        print("[DatabaseInflator] Inserting \(parts.count) parts...")
        
        let insertStartTime = Date()
        
        parts.forEach { part in
            
            partInsertStatement.insert(name: part.name, imageURL: part.part_img_url)
        }
        
        print("[DatabaseInflator] Inserted \(parts.count) parts in \(Date().elapsedTimeSince(insertStartTime))")
    }
}
