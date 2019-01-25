
import Foundation


struct DatabaseBuilder {
    
    
    static func buildDatabase(at url: URL) -> DatabaseInflator {
        
        let databaseFileURL = url
        
        print("[DatabaseController] Preparing database...")
        
        guard !FileManager.default.fileExists(atPath: databaseFileURL.path) else {
            
            fatalError("[DatabaseController] Cannot create database, file exists: \(databaseFileURL.path)")
        }
        
        let connection = SQLite_Connection(toDatabaseAt: databaseFileURL)
        
        connection.run("""
            CREATE TABLE colors(
                name CHAR(255) NOT NULL,
                rgb CHAR(6) NOT NULL,
                transparent BOOL NOT NULL
            );
            """
        )
        
        connection.run("""
            CREATE TABLE parts(
                name CHAR(255) NOT NULL,
                image_url CHAR(1024) NULL
            );
            """
        )
        
        let colorInsertStatement = connection.compile(
            "INSERT INTO colors (name, rgb, transparent) VALUES (?, ?, ?);"
        )
        
        let partInsertStatement = connection.compile(
            "INSERT INTO parts (name, image_url) VALUES (?, ?);"
        )
        
        return DatabaseInflator(
            
            connection: connection,
            
            colorInsertStatement: colorInsertStatement,
            partInsertStatement: partInsertStatement
        )
    }
}
