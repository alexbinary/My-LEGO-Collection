
import Foundation
import SQLite3



/// A connection to a SQLite database.
///
/// You open a connection with the `init(toDatabaseAt:)` initializer., passing
/// the path to the SQLite database file you want to open.
///
/// Instances of this class hold a pointeur to the underlying connection object.
/// It is important that you let the object be deallocated when you are done to
/// close the connection and release associated resources.
///
class SQLite_Connection {
    
    
    /// The SQLite pointer that represents the connection to the database.
    ///
    /// This pointer is guaranteed to always represent a valid, open connection
    /// to the database that was passed to the initializer.
    ///
    private(set) var pointer: OpaquePointer!

    
    /// Creates a connection to the database at the provided URL.
    ///
    /// This initializer opens the connection to the database. This initializer
    /// triggers a fatal error if the connection fails.
    ///
    /// To close the connection, you must let the instance be deallocated.
    ///
    init(toDatabaseAt url: URL) {
        
        guard sqlite3_open(url.path, &pointer) == SQLITE_OK else {
            
            fatalError("[SQLite_Connection] Opening database: \(url.path). SQLite error: \(errorMessage ?? "")")
        }
    }
    
    
    /// Deallocates the instance.
    ///
    /// This deinitializer closes the connection to the database.
    ///
    deinit {
        
        print("[SQLite_Connection] Closing connection.")
        
        sqlite3_close(pointer)
    }
}


extension SQLite_Connection {
    
    
    /// The latest error message produced on the connection.
    ///
    /// This is `nil` if no error message was produced yet.
    ///
    var errorMessage: String? {
        
        if let error = sqlite3_errmsg(pointer) {
            
            return String(cString: error)
            
        } else {
            
            return nil
        }
    }
}


extension SQLite_Connection {
    
    
    /// Creates a table in the database.
    ///
    /// - Parameter table: A description of the table to create.
    ///
    func create(table: DatabaseTable) {
        
        let query = SQLite_CreateTableQuery(table: table)
        
        let statement = SQLite_Statement(connection: self, query: query)
        
        statement.run()
    }
    
    
    /// Reads all rows from a table.
    ///
    /// - Parameter table: A description of the table to read from.
    ///
    /// - Returns: A dictionnary containing the value of each column.
    ///
    func readAllRows(from table: DatabaseTable) -> [[(column: DatabaseTableColumn, value: Any?)]] {
        
        let query = SQLite_SelectQuery(table: table)
        
        let statement = SQLite_Statement(connection: self, query: query)
        
        return statement.readResults() { statement in
            
            table.columns.enumerated().map { (index, column) in
                
                switch column.type {
                    
                case .bool:
                    
                    if column.nullable {
                        
                        fatalError("unsupported column type")
                        
                    } else {
                        
                        return (column: column, value: statement.readBool(at: index) as Any?)
                    }
                    
                case .char:
                    
                    if column.nullable {
                        
                        return (column: column, value: statement.readOptionalString(at: index))
                        
                    } else {
                        
                        return (column: column, value: statement.readString(at: index))
                    }
                }
            }
        }
    }
}
