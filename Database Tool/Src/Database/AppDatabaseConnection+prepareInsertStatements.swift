
import Foundation



extension LEGODatabase_Connection {
    
    
    func prepareColorInsertStatement() -> ColorInsert_Statement {
        
        return ColorInsert_Statement(connection: self)
    }
    
    
    func preparePartInsertStatement() -> PartInsertStatement {
        
        return PartInsertStatement(connection: self)
    }
}
