
import Foundation



extension SQLite_Connection {
    
    
    /// Reads all rows from a table.
    ///
    /// - Parameter table: A description of the table to read from.
    ///
    /// - Returns: A dictionnary containing the value of each column.
    ///
    func readAllRows(from table: SQLite_Table) -> [[SQLite_Column: SQLite_ColumnValue]] {
        
        let query = SQLite_SelectQuery(table: table)
        
        let statement = SQLite_Statement(connection: self, query: query)
        
        return statement.readResults() { statement in
            
            var row: [SQLite_Column: SQLite_ColumnValue] = [:]
            
            for (index, column) in table.columns.enumerated() {
                
                row[column] = statement.readValue(for: column, at: index)
            }
            
            return row
        }
    }
}
