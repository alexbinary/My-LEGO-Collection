
import Foundation



extension AppDatabaseConnection {
    
    
    func prepareColorInsertStatement() -> ColorInsertStatement {
        
        return ColorInsertStatement(connection: self)
    }
    
    
    func preparePartInsertStatement() -> PartInsertStatement {
        
        return PartInsertStatement(connection: self)
    }
}
