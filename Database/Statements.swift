
import Foundation



//class ColorInsertStatement: InsertStatement<AppDatabaseSchema.ColorsTable> {

class ColorInsertStatement: InsertStatement {
    
    
    let colorsTable = AppDatabaseSchema.ColorsTable()
    
    
    init(connection: SQLite_Connection) {
        
        super.init(for: colorsTable, connection: connection)
    }
    
    
    func insert(name: String, rgb: String, transparent: Bool) {
        
        insert([
            
            (column: colorsTable.nameColumn, value: name),
            (column: colorsTable.rgbColumn, value: rgb),
            (column: colorsTable.transparentColumn, value: transparent),
        ])
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

    
    let partsTable = AppDatabaseSchema.PartsTable()
    
    
    init(connection: SQLite_Connection) {
        
        super.init(for: partsTable, connection: connection)
    }
    
    
    func insert(name: String, imageURL: String?) {
        
        insert([
            
            (column: partsTable.nameColumn, value: name),
            (column: partsTable.imageURLColumn, value: imageURL),
        ])
        
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
    
    
    
}
