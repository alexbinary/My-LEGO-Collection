
import UIKit



/// A view controller that shows a list of LEGO colors.
///
/// This view controller uses a table view to present a list of colors from the
/// LEGO color palette. For each color, its name is presented along with a color
/// indicator that shows the actual color.
///
/// Use the `legoColors` property to set the colors that the controller shows.
///
class LegoColorsListViewController: UITableViewController {
    
    
    /// The colors that this controller shows.
    ///
    /// When you set this property, the view controller updates its content
    /// automatically.
    ///
    var legoColors: [LEGO_Color] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    
    /// Called after the controller's view is loaded into memory.
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Colors"
    }
}


extension LegoColorsListViewController {
    
    
    /// Return the number of rows in a given section of a table view.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Parameter section: An index number identifying the section in the table view.
    ///
    /// - Returns: The number of rows in the section.
    ///
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return legoColors.count
    }
    
    
    /// Returns the cell to insert in a particular location of the table view.
    ///
    /// - Parameter tableView: The table-view object requesting the cell.
    /// - Parameter indexPath: An index path locating a row in the table view.
    ///
    /// - Returns: The cell to insert in the specified location of the table view.
    ///
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let legoColor = legoColors[indexPath.row]
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel!.text = legoColor.name
        
        cell.detailTextLabel!.text = "████"
        cell.detailTextLabel!.textColor = UIColor(from: legoColor)
        
        return cell
    }
}
