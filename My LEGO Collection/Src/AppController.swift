
import UIKit


/// An object that manages root-level functions of the app.
///
/// There typically is only once instance of this class for the entire life of
/// the application. This object ultimately contains the entire state of the app.
///
/// The app controller is responsible for managing the app's windows and initial
/// view controllers.
///
class AppController {

    
    /// The app's main window.
    ///
    /// Releasing this reference causes the window to disappear.
    ///
    var mainWindow: UIWindow!
    
    
    /// Starts the app.
    ///
    /// This method:
    /// 1. loads the colors from the embedded database
    /// 1. instanciates a view controller to show the colors
    /// 1. creates the app's main window and show the view controller
    ///
    func start() {
        
        let databaseFileURL = Bundle.main.url(forResource: "db", withExtension: "sqlite")!
        
        var databaseReader: DatabaseReader? = DatabaseReader(forDatabaseAt: databaseFileURL)
        
        let legoColors = databaseReader!.readAllColors()
        let legoParts = databaseReader!.readAllParts()
        
        databaseReader = nil
        
        let dataViewController = DataViewController()
        dataViewController.legoColors = legoColors
        dataViewController.legoParts = legoParts
        
        mainWindow = UIWindow()
        mainWindow.rootViewController = dataViewController
        mainWindow.makeKeyAndVisible()
    }
}
