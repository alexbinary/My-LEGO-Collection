
import Foundation



/// A statement that inserts data into a table.
///
/// This class provides convenience methods that facilitate the execution of
/// "INSERT INTO" statements.
///
class SQLite_InsertStatement: SQLite_Statement {
    
    
    /// The table the statement inserts data into.
    ///
    private let table: SQLite_Table
    
    
    /// The query that was used to compile the statement.
    ///
    private let insertQuery: SQLite_InsertQuery
    
    
    /// Creates a new statement.
    ///
    /// - Parameter table: The table the statement should insert data into.
    /// - Parameter connection: The connection to use to compile the query.
    ///
    init(insertingInto table: SQLite_Table, connection: SQLite_Connection) {
        
        self.table = table
        self.insertQuery = SQLite_InsertQuery(insertingInto: table)
        
        super.init(connection: connection, query: insertQuery)
    }
}


extension SQLite_InsertStatement {
    
    
    /// Inserts values into the table.
    ///
    /// - Parameter columnValues: A dictionary that contain the value to insert
    ///             in each column.
    ///
    func insert(_ columnValues: [SQLite_Column: SQLite_QueryParameterValue]) {
        
        var parameterValues: [SQLite_QueryParameter: SQLite_QueryParameterValue] = [:]
        
        for (column, parameter) in insertQuery.parameters {
        
            guard let value = columnValues[column] else {
                
                fatalError("[SQLite_InsertStatement] Missing value for column: \(column). Trying to insert into table: \(table.name), values: \(columnValues)")
            }
            
            parameterValues[parameter] = value
        }
        
        _ = runThroughCompletion(with: parameterValues)
    }
}
