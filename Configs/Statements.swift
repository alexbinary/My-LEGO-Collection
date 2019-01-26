
import Foundation


class ColorInsertStatement: InsertStatement<AppDatabaseSchema.ColorsTable> {
    
    
    override func bind(_ row: AppDatabaseSchema.ColorsTable.Row) {
        
        bind([
            
            row.name,
            row.rgb,
            row.transparent
        ])
    }
}



class PartInsertStatement: InsertStatement<AppDatabaseSchema.PartsTable> {
    
    
    override func bind(_ row: AppDatabaseSchema.PartsTable.Row) {
        
        bind([
            
            row.name,
            row.rgb,
            row.transparent
            ])
    }
}
