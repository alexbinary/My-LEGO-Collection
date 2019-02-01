
import Foundation



/// A description of a column in a SQLite database table.
///
struct SQLite_Column: Hashable {

    
    /// The column's name.
    ///
    let name: String
    
    
    /// The column's type.
    ///
    let type: SQLite_ColumnType
    
    
    /// Whether the column can contain the value NULL.
    ///
    let nullable: Bool
}


extension SQLite_Column: SQLite_SQLRepresentable {
    
    
    /// The SQL string that represents the column.
    ///
    /// This property returns the SQL fragment that can be used in
    /// "CREATE TABLE" queries and other type of SQL queries where a table
    /// column need to be expressed.
    ///
    var sqlRepresentation: String {
        
        return [
            
            name,
            type.sqlRepresentation,
            nullable ? "NULL" : "NOT NULL",
            
        ].joined(separator: " ")
    }
}

