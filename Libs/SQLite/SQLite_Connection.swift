
import Foundation
import SQLite3


class SQLite_Connection
{
    private(set) var pointer: OpaquePointer!
    
    init(toDatabaseAt url: URL) {
        
        guard sqlite3_open(url.path, &pointer) == SQLITE_OK else {
            
            fatalError("[SQLite_Connection] Opening database: \(url.path). SQLite error: \(errorMessage ?? "")")
        }
    }
    
    deinit {
        
        print("[SQLite_Connection] Closing connection.")
        
        sqlite3_close(pointer)
    }
    
    var errorMessage: String? {
        
        if let error = sqlite3_errmsg(pointer) {
            
            return String(cString: error)
            
        } else {
            
            return nil
        }
    }
    
    func compile(_ query: String) -> SQLite_Statement {
        
        return SQLite_Statement(connection: self, query: query)
    }
    
    func run(_ query: String) {
        
        let statement = compile(query)
        
        statement.run()
    }
    
    /// Iterates over the results of a query and reads each row using the provided reader.
    ///
    /// - Parameter query: The SQL query to read the results of.
    /// - Parameter reader: A closure that takes the statement and returns an instance of the provided type.
    ///
    /// - Returns: One instance of the provided type for each result row.
    ///
    func readResults<ResultType>(of query: String, with reader: (SQLite_Statement) -> ResultType) -> [ResultType] {
        
        let statement = compile(query)
        
        let results = statement.readResults(with: reader)
        
        return results
    }
    
    
    
    func createTable<Type>(_ type: Type.Type) where Type: DatabaseTable {
        
        let query = SQLite_Connection.createTableSQLExpression(type)
        
        run(query)
    }
    
    
    static func createTableSQLExpression<Type>(_ type: Type.Type) -> String where Type: DatabaseTable {
        
        return [
            
//            "CREATE TABLE \(type.name)(",
//            type.columns.map(columnSQLExpression).joined(separator: ", "),
//            ");"
        
        ].joined()
    }
    
    
    static func columnSQLExpression(_ col: DatabaseTableColumn) -> String {
        
        return [
            
            col.name,
            columnTypeSQLExpression(col.type),
            col.nullable ? "NULL" : "NOT NULL"
            
        ].joined(separator: " ")
    }
    
    
    static func columnTypeSQLExpression(_ type: DatabaseTableColumnType) -> String {
        
        switch (type) {
            
        case .bool:
            
            return "BOOL"
            
        case .char(let size):
            
            return "CHAR(\(size))"
        }
    }
    
    
    
//    func getAllRows<TableType>(_ tableType: TableType.Type, with reader: (SQLite_Statement) -> TableType.TableRow) -> [TableType.TableRow] where TableType: DatabaseTable {
//        
//        let query = SQLite_Connection.selectSQLExpression(tableType)
//        
//        return readResults(of: query, with: reader)
//    }
    
    
    static func selectSQLExpression<TableType>(_ tableType: TableType.Type) -> String where TableType: DatabaseTable {
        
        return [
            
//            "SELECT * FROM",
//            tableType.name,
//            ";"
            
        ].joined(separator: " ")
    }
}
