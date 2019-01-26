
import Foundation



struct DatabaseBuilder {
    
    
    static func buildDatabase(at url: URL) -> DatabaseInflator {
        
        print("[DatabaseController] Preparing database at \(url.path)")
        
        guard !FileManager.default.fileExists(atPath: url.path) else {

            fatalError("[DatabaseController] Cannot create database, file exists: \(url.path)")
        }
        
        let connection = AppDatabaseConnection(toDatabaseAt: url)
        
        connection.createTable(AppDatabaseSchema.ColorsTable.self)
        connection.createTable(AppDatabaseSchema.PartsTable.self)
        
        let colorInsertStatement: ColorInsertStatement = connection.prepareColorInsertStatement()
        let partInsertStatement: PartInsertStatement = connection.preparePartInsertStatement()
        
        return DatabaseInflator(
            
            connection: connection,
            
            colorInsertStatement: colorInsertStatement,
            partInsertStatement: partInsertStatement
        )
    }
}
