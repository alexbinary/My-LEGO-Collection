
import Foundation



class LEGODatabase_PartInsertStatement: SQLite_InsertStatement {

    
    init(connection: SQLite_Connection) {
        
        super.init(insertingIntoTable: LEGODatabase.schema.partsTableDescription, connection: connection)
    }
    
    
    func insert(name: String, imageURL: String?) {
        
        insert([
            
            LEGODatabase.schema.partsTableDescription.nameColumn: name,
            LEGODatabase.schema.partsTableDescription.imageURLColumn: imageURL,
        ])
    }
}
