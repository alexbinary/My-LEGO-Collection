
import Foundation



struct DatabaseBuilder {
    
    
    static func buildDatabase(at url: URL) -> DatabaseInflator {
        
        print("[DatabaseController] Preparing database at \(url.path)")
        
        guard !FileManager.default.fileExists(atPath: url.path) else {

            fatalError("[DatabaseController] Cannot create database, file exists: \(url.path)")
        }
        
        let connection = LEGODatabase_Connection(toDatabaseAt: url)
        
        connection.createColorsTable()
        connection.createPartsTable()
        
        let colorInsertStatement = connection.prepareColorInsertStatement()
        let partInsertStatement = connection.preparePartInsertStatement()

        return DatabaseInflator(
            
            colorInsertStatement: colorInsertStatement,
            partInsertStatement: partInsertStatement
        )
    }
}
