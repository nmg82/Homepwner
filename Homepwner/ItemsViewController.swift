import UIKit

class ItemsViewController: UITableViewController {
  var itemStore: ItemStore!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
    
    let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
    tableView.contentInset = insets
    tableView.scrollIndicatorInsets = insets
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return itemStore.allItems.filter({$0.valueInDollars < 50}).count
    } else {
      return itemStore.allItems.filter({$0.valueInDollars > 50}).count
    }
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "Less than 50"
    } else {
      return "Greater than 50"
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let item: Item = {
      if indexPath.section == 0 {
        return itemStore.allItems.filter({$0.valueInDollars < 50})[indexPath.row]
      } else {
        return itemStore.allItems.filter({$0.valueInDollars > 50})[indexPath.row]
      }
    }()
    
    let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
    cell.textLabel?.text = item.name
    cell.detailTextLabel?.text = "$\(item.valueInDollars)"
    
    return cell
  }
}
