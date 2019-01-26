
import Foundation


class ColorInsertStatement: InsertStatement<AppDatabaseSchema.ColorsTable> {
    
    
    override func bind(_ row: AppDatabaseSchema.ColorsTable.TableRow) {
        
        bind([
            
            row.name,
            row.rgb,
            row.transparent
        ])
    }
}



class PartInsertStatement: InsertStatement<AppDatabaseSchema.PartsTable> {
    
    
    override func bind(_ row: AppDatabaseSchema.PartsTable.TableRow) {
        
        bind([
            
            row.name,
            row.imageURL,
        ])
    }
}
