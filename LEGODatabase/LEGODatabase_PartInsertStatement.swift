
import Foundation



class LEGODatabase_PartInsertStatement: SQLite_InsertStatement {

    
    init(connection: SQLite_Connection) {
        
        super.init(insertingInto: LEGODatabase.schema.partsTable, connection: connection)
    }
    
    
    func insert(name: String, imageURL: String?) {
        
        insert([
            
            LEGODatabase.schema.partsTable.nameColumn: name,
            LEGODatabase.schema.partsTable.imageURLColumn: imageURL,
        ])
    }
}
