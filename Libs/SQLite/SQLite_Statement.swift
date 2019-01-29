
import Foundation
import SQLite3



class SQLite_Statement {

    
    private(set) var connection: SQLite_Connection!
    
    
    private(set) var pointer: OpaquePointer!
    
    
    private(set) var query: SQLite_Query
    
    
    private(set) var boundValues: [(parameterName: String, value: Any?)] = []
    
    
    init(connection: SQLite_Connection, query: SQLite_Query) {
        
        self.connection = connection
        self.query = query
        
        guard sqlite3_prepare_v2(connection.pointer, query.sqlString, -1, &pointer, nil) == SQLITE_OK else {
            
            fatalError("[SQLite_Statement] Preparing query: \(query). SQLite error: \(connection.errorMessage ?? "")")
        }
    }
    
    
    deinit {
        
        sqlite3_finalize(pointer)
    }
}


extension SQLite_Statement {
    
    
    func run() {
        
        guard sqlite3_step(pointer) == SQLITE_DONE else {
            
            fatalError("[SQLite_Statement] Running query: \(query) with bindings: \(boundValues). SQLite error: \(connection.errorMessage ?? "")")
        }
    }
    
    
    func run(with values: [(parameterName: String, value: Any?)]) {
    
        bind(values)
        
        run()
    }
}


extension SQLite_Statement {
    
    
    func bind(_ values: [(parameterName: String, value: Any?)]) {

        sqlite3_reset(pointer)
        
        values.forEach { bind($0.value, for: $0.parameterName) }
        
        boundValues = values
    }
    

    func bind(_ value: Any?, for parameterName: String) {
        
        let int32Index = sqlite3_bind_parameter_index(pointer, parameterName)
        
        switch (value) {
            
        case let stringValue as String:
            
            let rawValue = NSString(string: stringValue).utf8String
            
            sqlite3_bind_text(pointer, int32Index, rawValue, -1, nil)
            
        case let boolValue as Bool:
            
            let rawValue = Int32(exactly: NSNumber(value: boolValue))!
            
            sqlite3_bind_int(pointer, int32Index, rawValue)
            
        case nil:
            
            sqlite3_bind_null(pointer, int32Index)
            
        default:
            
            fatalError("[SQLite_Statement] Binding value: \(String(describing: value)): unsupported type.")
        }
    }
}


extension SQLite_Statement {
    
    /// Iterates over the results of a prepared statement and reads each row using the provided reader.
    ///
    /// - Parameter statement: The prepared statement to read the results of.
    /// - Parameter reader: A closure that takes the statement and returns an instance of the provided type.
    ///
    /// - Returns: One instance of the provided type for each result row.
    ///
    func readResults<ResultType>(with reader: (SQLite_Statement) -> ResultType) -> [ResultType] {
        
        var results: [ResultType] = []
        
        while true {
            
            let stepResult = sqlite3_step(pointer)
            
            guard stepResult.isOneOf([SQLITE_ROW, SQLITE_DONE]) else {
                
                fatalError("[DatabaseController] sqlite3_step() returned \(stepResult) for query: \(query). SQLite error: \(connection.errorMessage ?? "")")
            }
            
            if stepResult == SQLITE_ROW {
                
                results.append(reader(self))
                
            } else {
                
                break
            }
        }
        
        return results
    }
    
    
}


extension SQLite_Statement {
    
    /// Reads a result value from a query as a string, expecting the value cannot be `NULL`.
    ///
    /// - Parameter statement: The prepared statement to read the value from.
    /// - Parameter index: The index of the column for which the value should be returned.
    ///
    /// - Returns: The result value as a string.
    ///
    /// Terminates with a fatal error if the value is `NULL`.
    ///
    func readString(at index: Int) -> String {
        
        let value = readOptionalString(at: index)
        
        guard value != nil else {
            
            fatalError("[DatabaseController] Found NULL while expecting non null string value at index: \(index) for results of query: \(query)")
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
    func readOptionalString(at index: Int) -> String? {
        
        if let raw = sqlite3_column_text(pointer, Int32(index)) {
            
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
    func readBool(at index: Int) -> Bool {
        
        let raw = sqlite3_column_int(pointer, Int32(index))
        
        return raw != 0
    }
}



//class InsertStatement<TableType>: Statement where TableType: DatabaseTable {
class InsertStatement: SQLite_Statement {
    
    
    let table: DatabaseTable
    
    
    let insertQuery: SQLite_InsertQuery
    
    
    init(for table: DatabaseTable, connection: SQLite_Connection) {
        
        self.table = table
        
        self.insertQuery = SQLite_InsertQuery(table: table)
        
        super.init(connection: connection, query: insertQuery)
    }
    
    
    //    init(connection: SQLite_Connection) {
    //
    //        let query = InsertStatement.insertSQLExpression(for: TableType.self)
    //
    //        super.init(connection: connection, query: query)
    //    }
    
    
    //    static func insertSQLExpression<Type>(for type: Type.Type) -> String where Type: DatabaseTable {
    //
    //        return [
    //
    ////            "INSERT INTO",
    ////            type.name,
    ////            "(\(type.columns.map { $0.name } .joined(separator: ", ")))",
    ////            "VALUES",
    ////            "(\(type.columns.map { _ in "?" } .joined(separator: ", ")))",
    ////            ";"
    //
    //        ].joined(separator: " ")
    //    }
    
    
    //    func insert(_ row: TableType.TableRow)
    //    {
    ////        bind(row.bindings)
    //
    //        self.run()
    //    }
    
    
    func insert(_ bindings: [(column: DatabaseTableColumn, value: Any?)]) {
        
        //        let query = SQLite_InsertQuery(table: table)
        //
        //        connection.run(query, with: values)
        
        let rawvalues = bindings.map { binding in
            
            return (
                parameterName: insertQuery.parameters.first(where: { $0.column.name == binding.column.name })!.parameterName,
                value: binding.value
            )
        }
        
        run(with: rawvalues)
    }
}
