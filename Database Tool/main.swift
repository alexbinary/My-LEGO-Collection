
import Foundation


let databaseFileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("db.sqlite")

let db = DatabaseController(forDatabaseAt: databaseFileURL)

db.prepare()

db.insert([Rebrickable_Color(name: "blue", rgb: "AAAAAA", is_trans: false)])

db.done()


//AppController().start()
//
//dispatchMain()
