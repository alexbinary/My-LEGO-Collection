
import UIKit



/// A view controller that shows a list of LEGO parts.
///
/// This view controller uses a table view to present a list of LEGO parts.
///
/// Use the `legoParts` property to set the parts that the controller shows.
///
class LegoPartsListViewController: UITableViewController {
    
    
    /// The parts that this controller shows.
    ///
    /// When you set this property, the view controller updates its content
    /// automatically.
    ///
    var legoParts: [LEGO_Part] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    
    /// Called after the controller's view is loaded into memory.
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Parts"
    }
}


extension LegoPartsListViewController {
    
    
    /// Return the number of rows in a given section of a table view.
    ///
    /// - Parameter tableView: The table-view object requesting this information.
    /// - Parameter section: An index number identifying the section in the table view.
    ///
    /// - Returns: The number of rows in the section.
    ///
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return legoParts.count
    }
    
    
    /// Returns the cell to insert in a particular location of the table view.
    ///
    /// - Parameter tableView: The table-view object requesting the cell.
    /// - Parameter indexPath: An index path locating a row in the table view.
    ///
    /// - Returns: The cell to insert in the specified location of the table view.
    ///
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let legoPart = legoParts[indexPath.row]
        
        let cellReuseIdentifier = "LegoPartsListTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LegoPartsListTableViewCell ?? LegoPartsListTableViewCell(reuseIdentifier: cellReuseIdentifier)
        
        cell.mainLabel.text = legoPart.name
        cell.imageURL = legoPart.imageURL
        
        return cell
    }
}
