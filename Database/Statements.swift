
import Foundation



class ColorInsertStatement: InsertStatement<AppDatabaseSchema.ColorsTable> {
    
    
    func insert(name: String, rgb: String, transparent: Bool) {
        
        insert(AppDatabaseSchema.ColorsTable.TableRow(name: name, rgb: rgb, transparent: transparent))
    }
    
    
    override func bind(_ row: AppDatabaseSchema.ColorsTable.TableRow) {

        bind([

            row.name,
            row.rgb,
            row.transparent
        ])
    }
}



class PartInsertStatement: InsertStatement<AppDatabaseSchema.PartsTable> {
    
    
    func insert(name: String, imageURL: String?) {
        
        insert(AppDatabaseSchema.PartsTable.TableRow(name: name, imageURL: imageURL))
    }
    
    
    override func bind(_ row: AppDatabaseSchema.PartsTable.TableRow) {

        bind([

            row.name,
            row.imageURL,
        ])
    }
}
