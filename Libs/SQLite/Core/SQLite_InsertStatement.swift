
import Foundation



/// A statement that inserts data into a table.
///
/// This class provides convenience methods that facilitate the execution of
/// statements that insert data into a table.
///
class SQLite_InsertStatement: SQLite_Statement {
    
    
    let table: SQLite_Table
    
    
    let insertQuery: SQLite_InsertQuery
    
    
    init(for table: SQLite_Table, connection: SQLite_Connection) {
        
        self.table = table
        
        self.insertQuery = SQLite_InsertQuery(table: table)
        
        super.init(connection: connection, query: insertQuery)
    }
    
    
    func insert(_ bindings: [(column: SQLite_Column, value: Any?)]) {
        
        let values = bindings.map { binding in
            
            return (
                parameterName: insertQuery.parameters.first(where: { $0.column.name == binding.column.name })!.parameterName,
                value: binding.value
            )
        }
        
        run(with: values)
    }
}
