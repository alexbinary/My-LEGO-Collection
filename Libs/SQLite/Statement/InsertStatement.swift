
import Foundation


class InsertStatement<Table>: Statement where Table: DatabaseTable {
    
    
//    let table: Table
//    
//    
//    init(table: Table) {
//        
//        self.table = table
//    }
//    
//    
    func insert(_ row: Table.TableRow) {
        
        self.bind(row)
        
        self.run()
    }
    
    
    func bind(_ row: Table.TableRow) {
        
    }
}
