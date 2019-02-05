
import Foundation



struct DatabaseReader {
    
    
    private var connection: LEGODatabase_Connection
    
    
    init(forDatabaseAt url: URL) {
        
        print("[DatabaseReader] opening connection")
        
        self.connection = LEGODatabase_Connection(toDatabaseAt: url)
    }
    
    
    func readAllColors() -> [LEGO_Color] {
        
        print("[DatabaseReader] fetching all colors")
        
        let startDate = Date()
 
        let colors = connection.readAllColors().map { color(from: $0) }
        
        print("[DatabaseController] fetched \(colors.count) colors in \(Date().elapsedTimeSince(startDate))")
        
        return colors
    }
    
    
    func readAllParts() -> [LEGO_Part] {
        
        print("[DatabaseReader] fetching all parts")
        
        let startDate = Date()
        
        let parts = connection.readAllParts().map { part(from: $0) }
        
        print("[DatabaseController] fetched \(parts.count) parts in \(Date().elapsedTimeSince(startDate))")
        
        return parts
    }
}


extension DatabaseReader {
    
    
    func color(from row: LEGODatabase_ColorsTable.Row) -> LEGO_Color {
        
        let name = row.name
        let rgb = RGB(fromHexString: row.rgb)
        let transparent = row.transparent
        
        return LEGO_Color(
            
            name: name,
            rgb: rgb,
            transparent: transparent
        )
    }
    
    
    private func part(from row: LEGODatabase_PartsTable.Row) -> LEGO_Part {
        
        let name = row.name
        let imageURL = row.imageURL != nil ? URL(string: row.imageURL!) : nil
        
        return LEGO_Part(
            
            name: name,
            imageURL: imageURL
        )
    }
}
