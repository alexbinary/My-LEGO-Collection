
import Foundation


//class InsertStatement<TableType>: Statement where TableType: DatabaseTable {
    class InsertStatement: Statement {
        
        
        let table: DatabaseTable
        
        
        let insertQuery: SQLite_InsertQuery
        
        
        init(for table: DatabaseTable, connection: SQLite_Connection) {
            
            self.table = table
            
            self.insertQuery = SQLite_InsertQuery(table: table)
            
            super.init(connection: connection, query: insertQuery.sql)
        }
    
    
//    init(connection: SQLite_Connection) {
//
//        let query = InsertStatement.insertSQLExpression(for: TableType.self)
//
//        super.init(connection: connection, query: query)
//    }
    
    
    static func insertSQLExpression<Type>(for type: Type.Type) -> String where Type: DatabaseTable {
        
        return [
            
//            "INSERT INTO",
//            type.name,
//            "(\(type.columns.map { $0.name } .joined(separator: ", ")))",
//            "VALUES",
//            "(\(type.columns.map { _ in "?" } .joined(separator: ", ")))",
//            ";"
            
        ].joined(separator: " ")
    }
    
    
//    func insert(_ row: TableType.TableRow)
//    {
////        bind(row.bindings)
//        
//        self.run()
//    }
    
    
        func insert(_ values: [(column: DatabaseTableColumn, value: Any?)]) {
        
//        let query = SQLite_InsertQuery(table: table)
//
//        connection.run(query, with: values)
        
            let rawvalues = values.map { value in
                
                return (
                    parameterName: insertQuery.parameters.first(where: { $0.column.name == value.column.name })!.parameterName,
                    value: value.value
                )
            }
            
        run(with: rawvalues)
    }
}
