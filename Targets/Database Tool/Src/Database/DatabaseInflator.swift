
import Foundation



struct DatabaseInflator {
    

//    private var colorInsertStatement: ColorInsertStatement
//    private var partInsertStatement: PartInsertStatement
    
    
    init(
        
//        colorInsertStatement: ColorInsertStatement,
//        partInsertStatement: PartInsertStatement
        
    ) {
        
//        self.colorInsertStatement = colorInsertStatement
//        self.partInsertStatement = partInsertStatement
    }
    
    
    func insert(_ colors: [Rebrickable_Color]) {
        
        print("[DatabaseController] Inserting \(colors.count) colors...")
        
        let insertStartTime = Date()
        
        colors.forEach { color in
            
//            colorInsertStatement.insert(name: color.name, rgb: color.rgb, transparent: color.is_trans)
        }
        
        print("[DatabaseController] Inserted \(colors.count) colors in \(Date().elapsedTimeSince(insertStartTime))")
    }
    
    
    func insert(_ parts: [Rebrickable_Part]) {
        
        print("[DatabaseController] Inserting \(parts.count) parts...")
        
        let insertStartTime = Date()
        
        parts.forEach { part in
            
//            partInsertStatement.insert(name: part.name, imageURL: part.part_img_url)
        }
        
        print("[DatabaseController] Inserted \(parts.count) parts in \(Date().elapsedTimeSince(insertStartTime))")
    }
}
