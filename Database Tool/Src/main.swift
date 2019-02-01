
import Foundation


let databaseFileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("db.sqlite")

var databaseInflator: DatabaseInflator! = DatabaseBuilder.buildDatabase(at: databaseFileURL)

databaseInflator.insert([Rebrickable_Color(name: "blue", rgb: "AAAAAA", is_trans: false)])
databaseInflator.insert([Rebrickable_Part(name: "part", part_img_url: "url")])
databaseInflator.insert([Rebrickable_Part(name: "part", part_img_url: nil)])

databaseInflator = nil

//AppController().start()
//
//dispatchMain()
