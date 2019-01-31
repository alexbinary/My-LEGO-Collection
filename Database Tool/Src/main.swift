
import Foundation


let databaseFileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("db.sqlite")

var databaseInflator: DatabaseInflator! = DatabaseBuilder.buildDatabase(at: databaseFileURL)

databaseInflator.insert([Rebrickable_Color(name: "blue", rgb: "AAAAAA", is_trans: false)])

databaseInflator = nil

//AppController().start()
//
//dispatchMain()
