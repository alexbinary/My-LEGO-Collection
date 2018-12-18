
import Foundation
import SQLite3


/// An object that controls the SQLite database.
///
/// This controller is specifically designed to read application data from a SQLite database at a provided path.
/// Currently, only LEGO parts and colors are supported.
///
class DatabaseController {
    
    
    /// The URL to the database file that this instance controls.
    ///
    private let databaseFileURL: URL
    
    
    /// A pointer to the active database connection.
    ///
    private var dbConnectionPointer: OpaquePointer!
    
    
    /// Creates a new instance that controls the database at the provided URL.
    ///
    init(forDatabaseAt url: URL) {
        
        databaseFileURL = url
        
        print("[DatabaseController] target: \(databaseFileURL)")
    }
}


extension DatabaseController {
    
    
    /// Opens the connection to the database.
    ///
    /// You must call this method before you call any other method.
    ///
    func open() {
        
        print("[DatabaseController] opening connection")
        
        guard sqlite3_open(databaseFileURL.path, &dbConnectionPointer) == SQLITE_OK else {
            
            fatalError("🚫 [DatabaseController] Opening database: \(databaseFileURL.path). SQLite error: \(sqliteErrorMessage ?? "")")
        }
    }
    
    
    /// Closes the connection to the database.
    ///
    /// You cannot call this method if you have not called `open()` before.
    ///
    func close() {
        
        print("[DatabaseController] closing connection")
        
        sqlite3_close(dbConnectionPointer)
    }
}


extension DatabaseController {
    
    
    /// Loads all colors from the database.
    ///
    /// You must call `open()` before you call this method.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    /// - Returns: The colors. Ordering not guaranteed.
    ///
    func getAllColors() -> [LEGO_Color] {
        
        print("[DatabaseController] fetching all colors")
        
        let startDate = Date()
        
        let colors = readResults(of: "SELECT * FROM Colors;", reader: { color(fromResultsOf: $0) })
        
        print("[DatabaseController] fetched \(colors.count) colors in \(Date().elapsedTimeSince(startDate))")
        
        return colors
    }
    
    
    /// Loads all parts from the database.
    ///
    /// You must call `open()` before you call this method.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    /// - Returns: The parts. Ordering not guaranteed.
    ///
    func getAllParts() -> [LEGO_Part] {
        
        print("[DatabaseController] fetching all parts")
        
        let startDate = Date()
        
        let parts = readResults(of: "SELECT * FROM Parts;", reader: { part(fromResultsOf: $0) })
        
        print("[DatabaseController] fetched \(parts.count) parts in \(Date().elapsedTimeSince(startDate))")
        
        return parts
    }
}


private extension DatabaseController {
    
    
    /// A type that groups a compiled statement pointer and the original SQL query.
    ///
    private typealias Statement = (query: String, pointer: OpaquePointer)
    
    
    /// Compiles the given query into an executable statement.
    ///
    /// - Parameter query: The SQL query to compile into a statement.
    ///
    /// - Returns: The compiled statement.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    private func compile(query: String) -> Statement {
        
        var pointer: OpaquePointer? = nil
        
        guard sqlite3_prepare_v2(dbConnectionPointer, query, -1, &pointer, nil) == SQLITE_OK else {
            
            fatalError("🚫 [DatabaseController] Compiling query: \(query). SQLite error: \(sqliteErrorMessage ?? "")")
        }
        
        return Statement(query: query, pointer: pointer!)
    }
    
    
    /// Iterates over the results of a prepared statement and reads each row using the provided reader.
    ///
    /// - Parameter statement: The prepared statement to read the results of.
    /// - Parameter reader: A closure that takes the statement and returns an instance of the provided type.
    ///
    /// - Returns: One instance of the provided type for each result row.
    ///
    private func readResults<ResultType>(of statement: Statement, reader: (Statement) -> ResultType) -> [ResultType] {
        
        var results: [ResultType] = []
        
        while true {
            
            let stepResult = sqlite3_step(statement.pointer)
            
            guard stepResult.isOneOf([SQLITE_ROW, SQLITE_DONE]) else {
                
                fatalError("🚫 [DatabaseController] sqlite3_step() returned \(stepResult) for query: \(statement.query). SQLite error: \(sqliteErrorMessage ?? "")")
            }
            
            if stepResult == SQLITE_ROW {
                
                results.append(reader(statement))
                
            } else {
                
                break
            }
        }
        
        return results
    }
    
    
    /// Iterates over the results of a query and reads each row using the provided reader.
    ///
    /// - Parameter query: The SQL query to read the results of.
    /// - Parameter reader: A closure that takes the statement and returns an instance of the provided type.
    ///
    /// - Returns: One instance of the provided type for each result row.
    ///
    private func readResults<ResultType>(of query: String, reader: (Statement) -> ResultType) -> [ResultType] {
        
        let statement = compile(query: query)
        
        let results = readResults(of: statement, reader: reader)
        
        sqlite3_finalize(statement.pointer)
        
        return results
    }
    
    
    /// Reads a result value from a query as a string, expecting the value cannot be `NULL`.
    ///
    /// - Parameter statement: The prepared statement to read the value from.
    /// - Parameter index: The index of the column for which the value should be returned.
    ///
    /// - Returns: The result value as a string.
    ///
    /// Terminates with a fatal error if the value is `NULL`.
    ///
    private func readString(from statement: Statement, at index: Int) -> String {
        
        let value = readOptionalString(from: statement, at: index)
        
        guard value != nil else {
            
            fatalError("🚫 [DatabaseController] Found NULL while expecting non null string value at index: \(index) for results of query: \(statement.query)")
        }
        
        return value!
    }
    
    
    /// Reads a result value from a query as a string, expecting the value can be `NULL`.
    ///
    /// - Parameter statement: The prepared statement to read the value from.
    /// - Parameter index: The index of the column for which the value should be returned.
    ///
    /// - Returns: The result value as a string, or nil if the database value was `NULL`.
    ///
    private func readOptionalString(from statement: Statement, at index: Int) -> String? {
        
        if let raw = sqlite3_column_text(statement.pointer, Int32(index)) {
        
            return String(cString: raw)
            
        } else {
            
            return nil
        }
    }
    
    
    /// Reads a result value from a query as a boolean value.
    ///
    /// - Note: Reading a boolean value when the database value is `NULL` produces `false`.
    ///
    /// - Parameter statement: The prepared statement to read the value from.
    /// - Parameter index: The index of the column for which the value should be returned.
    ///
    /// - Returns: The result value as a boolean value.
    ///
    private func readBool(from statement: Statement, at index: Int) -> Bool {
        
        let raw = sqlite3_column_int(statement.pointer, Int32(index))
        
        return raw != 0
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


private extension DatabaseController {
    
    
    /// Reads a result value from a query as an RGB value represented by a hexadecimal string.
    ///
    /// - Parameter statement: The prepared statement to read the value from.
    /// - Parameter index: The index of the column for which the value should be returned.
    ///
    /// - Returns: The result value as an RGB value.
    ///
    private func readRGB(from statement: Statement, at index: Int) -> RGB {
        
        let raw = readString(from: statement, at: index)
        
        return RGB(fromHexString: raw)
    }
    
    
    /// Reads a result value from a query as a URL.
    ///
    /// - Parameter statement: The prepared statement to read the value from.
    /// - Parameter index: The index of the column for which the value should be returned.
    ///
    /// - Returns: The result value as a URL, or nil if the database value was `NULL`.
    ///
    /// Terminates with a fatal error if the value is not `NULL` and does not represent a valid URL.
    ///
    private func readOptionalURL(from statement: Statement, at index: Int) -> URL? {
        
        if let raw = readOptionalString(from: statement, at: index) {
        
            guard let url = URL(string: raw) else {
                
                fatalError("🚫 [DatabaseController] Parsing URL from string value: \"\(raw)\" at index: \(index) for results of query: \(statement.query)")
            }
            
            return url
            
        } else {
            
            return nil
        }
    }
    
    
    /// Creates an instance of `LEGO_Color` from the result columns of a statement.
    ///
    /// - Parameter statement: The statement from which data should be read.
    ///
    /// - Returns: An instance of `LEGO_Color` constructed from the result columns of the statement.
    ///
    private func color(fromResultsOf statement: Statement) -> LEGO_Color {
        
        let name = readString(from: statement, at: 0)
        let rgb = readRGB(from: statement, at: 1)
        let transparent = readBool(from: statement, at: 2)
        
        return LEGO_Color(
            
            name: name,
            rgb: rgb,
            transparent: transparent
        )
    }
    
    
    /// Creates an instance of `LEGO_Part` from the result columns of a statement.
    ///
    /// - Parameter statement: The statement from which data should be read.
    ///
    /// - Returns: An instance of `LEGO_Part` constructed from the result columns of the statement.
    ///
    private func part(fromResultsOf statement: Statement) -> LEGO_Part {
        
        let name = readString(from: statement, at: 0)
        let imageURL = readOptionalURL(from: statement, at: 1)
        
        return LEGO_Part(
            
            name: name,
            imageURL: imageURL
        )
    }
}
