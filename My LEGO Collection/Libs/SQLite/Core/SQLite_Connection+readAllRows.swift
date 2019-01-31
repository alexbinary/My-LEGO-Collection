
import Foundation



extension SQLite_Connection {
    
    
    /// Reads all rows from a table.
    ///
    /// - Parameter table: A description of the table to read from.
    ///
    /// - Returns: A dictionnary containing the value of each column.
    ///
    func readAllRows(from table: SQLite_Table) -> [[(column: SQLite_Column, value: Any?)]] {
        
        let query = SQLite_SelectQuery(table: table)
        
        let statement = SQLite_Statement(connection: self, query: query)
        
        return statement.readResults() { statement in
            
            table.columns.enumerated().map { (index, column) in
                
                switch column.type {
                    
                case .bool:
                    
                    return (column: column, value: statement.readBool(at: index) as Any?)
                    
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
