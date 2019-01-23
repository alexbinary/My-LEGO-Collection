
import Foundation
import SQLite3


/// An object that controls the SQLite database.
///
/// This controller is specifically designed to seed a SQLite database at a
/// provided path with data from the Rebrickable webservice.
///
/// The first thing to do once you have created a controller is to call `prepare()`.
/// The `prepare()` method does the following things:
/// 1. create the database file
/// 1. connect to the database
/// 1. create the tables
/// 1. compile the insert queries
///
/// After you have called `prepare()`, call `insert(_:)` to insert data.
///
/// When you have inserted all your data, call `done()` to close the connection
/// and release resources.
///
class DatabaseController {
    
    
    /// The URL to the database file that this instance controls.
    ///
    private let databaseFileURL: URL
    
    
    /// A pointer to the database connection.
    ///
    private var dbConnectionPointer: OpaquePointer!
    
    
    /// The executable statement for the insertion of colors.
    ///
    private var colorInsertStatement: Statement!
    
    
    /// The executable statement for insertion of parts.
    ///
    private var partInsertStatement: Statement!
    
    
    /// Creates a new instance that controls the database at the provided URL.
    ///
    init(forDatabaseAt url: URL) {
        
        databaseFileURL = url
        
        print("[DatabaseController] target: \(databaseFileURL)")
    }
}


extension DatabaseController {
    
    
    /// Makes the database ready to receive inserts.
    ///
    /// You must call this method before you start inserting data. Inserting data
    /// without calling this method results in undefined behavior.
    ///
    /// This method:
    /// 1. creates the database file
    /// 1. connects to the database
    /// 1. creates the tables
    /// 1. compiles the insert queries
    ///
    /// Terminates with a fatal error if an error occurs at any of these steps.
    ///
    func prepare() {
        
        print("[DatabaseController] preparing database...")
        
        guard !FileManager.default.fileExists(atPath: databaseFileURL.path) else {
            
            fatalError("[DatabaseController] Cannot create database, file exists: \(databaseFileURL.path)")
        }
        
        guard sqlite3_open(databaseFileURL.path, &dbConnectionPointer) == SQLITE_OK else {
            
            fatalError("[DatabaseController] Opening database: \(databaseFileURL.path). SQLite error: \(sqliteErrorMessage ?? "")")
        }
        
        run("""
            CREATE TABLE colors(
                name CHAR(255) NOT NULL,
                rgb CHAR(6) NOT NULL,
                transparent BOOL NOT NULL
            );
            """
        )
        
        run("""
            CREATE TABLE parts(
                name CHAR(255) NOT NULL,
                image_url CHAR(1024) NULL
            );
            """
        )
        
        colorInsertStatement = compile(
            "INSERT INTO colors (name, rgb, transparent) VALUES (?, ?, ?);"
        )
        
        partInsertStatement = compile(
            "INSERT INTO parts (name, image_url) VALUES (?, ?);"
        )
    }
    
    
    /// Inserts the provided colors in the database.
    ///
    /// You must call `prepare()` before you call this method. Inserting data
    /// without calling `prepare()` results in undefined behavior.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    func insert(_ colors: [Rebrickable_Color]) {
        
        print("[DatabaseController] inserting \(colors.count) colors...")
        
        let insertStartTime = Date()
        
        colors.forEach { insert([$0.name, $0.rgb, $0.is_trans], using: colorInsertStatement) }
        
        print("[DatabaseController] inserted \(colors.count) colors in \(Date().elapsedTimeSince(insertStartTime))")
    }
    
    
    /// Inserts the provided parts in the database.
    ///
    /// You must call `prepare()` before you call this method. Inserting data
    /// without calling `prepare()` results in undefined behavior.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    func insert(_ parts: [Rebrickable_Part]) {
        
        print("[DatabaseController] inserting \(parts.count) parts...")
        
        let insertStartTime = Date()
        
        parts.forEach { insert([$0.name, $0.part_img_url], using: partInsertStatement) }
        
        print("[DatabaseController] inserted \(parts.count) parts in \(Date().elapsedTimeSince(insertStartTime))")
    }
    
    
    /// Closes the connection to the database and releases resources.
    ///
    /// You can only call this method after you have called `prepare()`. Calling
    /// this method without calling `prepare()` first results in undefined behavior.
    ///
    func done() {
        
        print("[DatabaseController] releasing resources...")
        
        sqlite3_finalize(colorInsertStatement.pointer)
        
        sqlite3_close(dbConnectionPointer)
    }
}


private extension DatabaseController {
    
    
    /// A type that groups a compiled statement pointer and the original SQL query.
    ///
    typealias Statement = (query: String, pointer: OpaquePointer, bindings: [Any?])
    
    
    /// Compiles the given query into an executable statement.
    ///
    /// - Parameter query: The SQL query to compile into a statement.
    ///
    /// - Returns: The compiled statement.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    private func compile(_ query: String) -> Statement {
        
        var pointer: OpaquePointer? = nil
        
        guard sqlite3_prepare_v2(dbConnectionPointer, query, -1, &pointer, nil) == SQLITE_OK else {
            
            fatalError("[DatabaseController] Compiling query: \(query). SQLite error: \(sqliteErrorMessage ?? "")")
        }
        
        return Statement(query: query, pointer: pointer!, bindings: [])
    }
    
    
    /// Executes the given statement.
    ///
    /// - Parameter statement: The statement to execute.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    private func run(_ statement: Statement) {
        
        guard sqlite3_step(statement.pointer) == SQLITE_DONE else {
            
            fatalError("[DatabaseController] Running query: \(statement.query) with bindings: \(statement.bindings). SQLite error: \(sqliteErrorMessage ?? "")")
        }
    }
    
    
    /// Compiles then runs a given SQL query.
    ///
    /// - Parameter query: The SQL query to be compiled then run.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    private func run(_ query: String) {
        
        let statement = compile(query)
        
        run(statement)
        
        sqlite3_finalize(statement.pointer)
    }
    
    
    /// Binds given values to given statement then runs the statement.
    ///
    /// - Parameter values: The values to bind to the statement, in order.
    /// - Parameter statement: The statement to bind the values to and then execute.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    private func insert(_ values: [Any?], using statement: Statement) {
        
        sqlite3_reset(statement.pointer)
        
        values.enumerated().forEach { bind($0.element, statement: statement.pointer, index: $0.offset + 1) }
        
        var statementWithBindings = statement
        
        statementWithBindings.bindings = values
        
        run(statementWithBindings)
    }
    
    
    /// Binds a given value to a given statement.
    ///
    /// - Parameter value: The value to bind to the statement.
    /// - Parameter statement: Pointer to the statement to bind the value to.
    /// - Parameter index: The index to bind the value at.
    ///
    private func bind(_ value: Any?, statement: OpaquePointer, index: Int) {
        
        let int32Index = Int32(exactly: index)!
        
        switch (value) {
            
        case let stringValue as String:
            
            let rawValue = NSString(string: stringValue).utf8String
            
            sqlite3_bind_text(statement, int32Index, rawValue, -1, nil)
            
        case let boolValue as Bool:
            
            let rawValue = Int32(exactly: NSNumber(value: boolValue))!
            
            sqlite3_bind_int(statement, int32Index, rawValue)
            
        case nil:
            
            sqlite3_bind_null(statement, int32Index)
            
        default:
            
            fatalError("[DatabaseController] Binding value: \(String(describing: value)): Unsupported type.")
        }
    }
    
    
    /// The latest error message generated by the SQLite engine.
    ///
    /// This is `nil` if no error message has been generated yet.
    ///
    private var sqliteErrorMessage: String? {
        
        if let error = sqlite3_errmsg(dbConnectionPointer) {
            
            return String(cString: error)
            
        } else {
            
            return nil
        }
    }
}
