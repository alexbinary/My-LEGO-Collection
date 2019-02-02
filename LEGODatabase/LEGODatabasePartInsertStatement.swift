
import Foundation



class LEGODatabasePartInsertStatement: SQLite_InsertStatement {

    
    init(connection: SQLite_Connection) {
        
        super.init(for: LEGODatabase.schema.partsTable, connection: connection)
    }
    
    
    func insert(name: String, imageURL: String?) {
        
        insert([
            
            LEGODatabase.schema.partsTable.nameColumn: name,
            LEGODatabase.schema.partsTable.imageURLColumn: imageURL,
        ])
    }
}
