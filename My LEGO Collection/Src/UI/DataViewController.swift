
import UIKit


/// A view controller that presents all the data.
///
/// This view controller is a tab bar controller that presents a list of LEGO colors and LEGO parts.
///
/// Use the `legoColors` property to set the LEGO colors that the controller shows.
/// Use the `legoParts` property to set the LEGO parts that the controller shows.
///
class DataViewController: UITabBarController {
    
    
    /// The colors that this controller shows.
    ///
    /// When you set this property, the view controller updates its content
    /// automatically.
    ///
    var legoColors: [LEGO_Color] {
        get {
            return colorsListViewController.legoColors
        }
        set {
            colorsListViewController.legoColors = newValue
        }
    }
    
    
    /// The parts that this controller shows.
    ///
    /// When you set this property, the view controller updates its content
    /// automatically.
    ///
    var legoParts: [LEGO_Part] {
        get {
            return partsListViewController.legoParts
        }
        set {
            partsListViewController.legoParts = newValue
        }
    }
    
    
    /// The view controller used to show the list of LEGO colors.
    ///
    private var colorsListViewController: LegoColorsListViewController!
    
    
    /// The view controller used to show the list of LEGO parts.
    ///
    private var partsListViewController: LegoPartsListViewController!
    
    
    /// Called after the controller's view is loaded into memory.
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
    
        colorsListViewController = LegoColorsListViewController()
        partsListViewController = LegoPartsListViewController()
        
        viewControllers = [
            
            colorsListViewController,
            partsListViewController,
        ]
    }
}
