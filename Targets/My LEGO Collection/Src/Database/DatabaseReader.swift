
import Foundation



struct DatabaseReader {
    
    
    private var connection: AppDatabaseConnection
    
    
    init(forDatabaseAt url: URL) {
        
        print("[DatabaseReader] opening connection")
        
        self.connection = AppDatabaseConnection(toDatabaseAt: url)
    }
    
    
    func readAllColors() -> [LEGO_Color] {
        
        print("[DatabaseReader] fetching all colors")
        
        let startDate = Date()
 
        let colors = connection.getAllColors().map { color(from: $0) }
        
        print("[DatabaseController] fetched \(colors.count) colors in \(Date().elapsedTimeSince(startDate))")
        
        return colors
    }
    
    
    func readAllParts() -> [LEGO_Part] {
        
        print("[DatabaseReader] fetching all parts")
        
        let startDate = Date()
        
        let parts = connection.getAllParts().map { part(from: $0) }
        
        print("[DatabaseController] fetched \(parts.count) parts in \(Date().elapsedTimeSince(startDate))")
        
        return parts
    }
}


extension DatabaseReader {
    
    
    func color(from row: AppDatabaseSchema.ColorsTable.TableRow) -> LEGO_Color {
        
        let name = row.name
        let rgb = RGB(fromHexString: row.rgb)
        let transparent = row.transparent
        
        return LEGO_Color(
            
            name: name,
            rgb: rgb,
            transparent: transparent
        )
    }
    
    
    private func part(from row: AppDatabaseSchema.PartsTable.TableRow) -> LEGO_Part {
        
        let name = row.name
        let imageURL = row.imageURL != nil ? URL(string: row.imageURL!) : nil
        
        return LEGO_Part(
            
            name: name,
            imageURL: imageURL
        )
    }
}