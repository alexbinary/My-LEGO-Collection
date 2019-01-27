
import Foundation



//class ColorInsertStatement: InsertStatement<AppDatabaseSchema.ColorsTable> {

class ColorInsertStatement: InsertStatement {
    
    
    init(connection: SQLite_Connection) {
        
        super.init(for: AppDatabaseSchema.ColorsTable(), connection: connection)
    }
    
    
    func insert(name: String, rgb: String, transparent: Bool) {
        
//        insert([name, rgb, transparent])
    }
    
    
//    override func bind(_ row: AppDatabaseSchema.ColorsTable.TableRow) {
//
//        bind([
//
//            row.name,
//            row.rgb,
//            row.transparent
//        ])
//    }
    
    
    
}



//class PartInsertStatement: InsertStatement<AppDatabaseSchema.PartsTable> {
class PartInsertStatement: InsertStatement {

    
    func insert(name: String, imageURL: String?) {
        
//        insert(AppDatabaseSchema.PartsTable.TableRow(name: name, imageURL: imageURL))
        
//        insert([name, imageURL])
    }
    
    
//    override func bind(_ row: AppDatabaseSchema.PartsTable.TableRow) {
//
//        bind([
//
//            row.name,
//            row.imageURL,
//        ])
//    }
    
    
    init(connection: SQLite_Connection) {
        
        super.init(for: AppDatabaseSchema.PartsTable(), connection: connection)
    }
}
