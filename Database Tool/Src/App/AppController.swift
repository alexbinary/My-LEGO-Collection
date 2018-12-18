
import Foundation


/// An object that manages root-level functions of the app.
///
/// There should be only once instance of this class for the entire life of the
/// application. This object ultimately contains the entire state of the app.
///
class AppController {
    
    
    /// The URL to the database file that should be created.
    ///
    private let databaseFileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("db.sqlite")
    
    
    /// The API key to use when contacting the Rebrickable web service.
    ///
    private let rebrickableApiKey = Rebrickable_APIKey("fbaba98cc0deb97795cc9467d12562ba")
    
    
    /// The database controller used in the app.
    ///
    private var db: DatabaseController!
    
    
    /// The Rebrickable API client used in the app.
    ///
    private var rebrickable: Rebrickable_APIClient!
    
    
    /// The internal serial queue used to execute database operation in parallel of other operations.
    ///
    private var dbQueue: DispatchQueue!

    
    /// Marks which download operations have completed.
    ///
    private var completedDownloads: Set<DownloadOperation> = []
    
    
    /// Starts the app.
    ///
    /// This method is heavily asynchronous, you must call `dispatchMain()` to
    /// keep the app running while work initiated by this method completes.
    ///
    /// This method downloads data from Rebrickable and inserts it in the
    /// database. Downloads and database operations happen in parallel.
    ///
    /// The program exits when everything is downloaded and inserted in the
    /// database.
    ///
    func start() {

        db = DatabaseController(forDatabaseAt: databaseFileURL)
        
        rebrickable = Rebrickable_APIClient(with: rebrickableApiKey)
        
        dbQueue = DispatchQueue(label: "")
        
        dbQueue.async {
        
            self.db.prepare()
        }
        
        rebrickable.getAllColors(
            
            batchProcessor: { colors in
                
                self.dbQueue.async {
                
                    self.db.insert(colors: colors)
                }
            },
            
            completionHandler: {
        
                self.downloadCompleted(.colors)
            }
        )
        
        rebrickable.getAllParts(
            
            batchProcessor: { parts in
                
                self.dbQueue.async {
                    
                    self.db.insert(parts: parts)
                }
            },
            
            completionHandler: {
                
                self.downloadCompleted(.parts)
            }
        )
    }
}


private extension AppController {
    
    
    /// List of downloads performed in the app.
    ///
    private enum DownloadOperation: CaseIterable {
        
        case colors
        case parts
    }
    
    
    /// Marks the provided download as completed and finalizes the app if all downloads have completed.
    ///
    private func downloadCompleted(_ download: DownloadOperation) {
        
        completedDownloads.insert(download)
        
        if completedDownloads == Set(DownloadOperation.allCases) {
            
            finish()
        }
    }
    
    
    /// Finalizes operations and exits.
    ///
    private func finish() {
        
        dbQueue.sync {
            
            db.done()
        }
        
        var fileSizeString = ""
        
        if let attr = try? FileManager.default.attributesOfItem(atPath: self.databaseFileURL.path) {
            
            let fileSize = (attr as NSDictionary).fileSize()
            
            fileSizeString = ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
        }
        
        print(
            """
            
            📦 Successfully generated database!
            \t\(self.databaseFileURL.path)
            \t\(fileSizeString)
            """
        )
        
        exit(EXIT_SUCCESS)
    }
}
