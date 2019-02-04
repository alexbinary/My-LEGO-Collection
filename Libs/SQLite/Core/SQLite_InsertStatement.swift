
import Foundation



/// A statement that inserts data into a table in a SQLite database.
///
/// This class provides convenience methods that facilitate the execution of
/// queries of the form "INSERT INTO <table>;".
///
class SQLite_InsertStatement: SQLite_Statement {
    
    
    /// A description of the table the statement inserts data into.
    ///
    private let tableDescription: SQLite_TableDescription
    
    
    /// The query that was used to compile the statement.
    ///
    private let insertQuery: SQLite_InsertQuery
    
    
    /// Creates a new statement.
    ///
    /// - Parameter tableDescription: The table the statement should insert data
    ///             into.
    /// - Parameter connection: The connection to use to compile the query.
    ///
    init(insertingIntoTable tableDescription: SQLite_TableDescription, connection: SQLite_Connection) {
        
        self.tableDescription = tableDescription
        self.insertQuery = SQLite_InsertQuery(insertingIntoTable: tableDescription)
        
        super.init(compiling: insertQuery, on: connection)
    }
}


extension SQLite_InsertStatement {
    
    
    /// Inserts values into the table.
    ///
    /// - Parameter columnValues: A dictionary that contain the value to insert
    ///             in each column.
    ///
    func insert(_ columnValues: [SQLite_ColumnDescription: SQLite_QueryParameterValue]) {
        
        var parameterValues: [SQLite_QueryParameter: SQLite_QueryParameterValue] = [:]
        
        for (column, parameter) in insertQuery.parameters {
        
            guard let value = columnValues[column] else {
                
                fatalError("[SQLite_InsertStatement] Missing value for column: \(column). Trying to insert into table: \(tableDescription.name), values: \(columnValues)")
            }
            
            parameterValues[parameter] = value
        }
        
        _ = runThroughCompletion(with: parameterValues)
    }
}
