
import Foundation


class InsertStatement<TableType>: Statement where TableType: DatabaseTable {
    
    
    init(connection: SQLite_Connection) {
        
        let query = InsertStatement.insertSQLExpression(for: TableType.self)
        
        super.init(connection: connection, query: query)
    }
    
    
    static func insertSQLExpression<Type>(for type: Type.Type) -> String where Type: DatabaseTable {
        
        return [
            
            "INSERT INTO",
            type.name,
            "(\(type.columns.map { $0.name } .joined(separator: ", ")))",
            "VALUES",
            "(\(type.columns.map { _ in "?" } .joined(separator: ", ")))",
            ";"
            
        ].joined(separator: " ")
    }
    
    
    func insert(_ row: TableType.TableRow)
    {
        self.bind(row)
        
        self.run()
    }
    
    
    func bind(_ row: TableType.TableRow) {
        
        fatalError("Must override")
    }
}
