
import Foundation



struct DatabaseInflator {
    

    private var connection: AppDatabaseConnection
    
    private var colorInsertStatement: ColorInsertStatement
    private var partInsertStatement: PartInsertStatement
    
    
    init(
        
        connection: AppDatabaseConnection,
        
        colorInsertStatement: ColorInsertStatement,
        partInsertStatement: PartInsertStatement
        
    ) {
        
        self.connection = connection
        self.colorInsertStatement = colorInsertStatement
        self.partInsertStatement = partInsertStatement
    }
    
    
    func insert(_ colors: [Rebrickable_Color]) {
        
        print("[DatabaseController] Inserting \(colors.count) colors...")
        
        let insertStartTime = Date()
        
        colors.forEach { color in
            
            colorInsertStatement.insert(AppDatabaseSchema.ColorsTable.TableRow(name: color.name, rgb: color.rgb, transparent: color.is_trans))
        }
        
        print("[DatabaseController] Inserted \(colors.count) colors in \(Date().elapsedTimeSince(insertStartTime))")
    }
    
    
    func insert(_ parts: [Rebrickable_Part]) {
        
        print("[DatabaseController] Inserting \(parts.count) parts...")
        
        let insertStartTime = Date()
        
        parts.forEach { part in
            
            partInsertStatement.insert(AppDatabaseSchema.PartsTable.TableRow(name: part.name, imageURL: part.part_img_url))
        }
        
        print("[DatabaseController] Inserted \(parts.count) parts in \(Date().elapsedTimeSince(insertStartTime))")
    }
}
