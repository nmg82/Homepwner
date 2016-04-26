import UIKit

class ItemsViewController: UITableViewController {
  var itemStore: ItemStore!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
    
    let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
    tableView.contentInset = insets
    tableView.scrollIndicatorInsets = insets
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 65
  }
  
  @IBAction func addNewItem(sender: AnyObject) {
    let newItem = itemStore.createItem()
    
    if let index = itemStore.allItems.indexOf(newItem) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
  }
  
  @IBAction func toggleEditingMode(sender: AnyObject) {
    if editing {
      sender.setTitle("Edit", forState: .Normal)
      setEditing(false, animated: true)
    } else {
      sender.setTitle("Done", forState: .Normal)
      setEditing(true, animated: true)
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemStore.allItems.count + 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
    cell.updateLabels()

    if itemStore.allItems.count == 0 || indexPath.row >= itemStore.allItems.count {
      cell.nameLabel.text = "No more items!"
      cell.serialNumberLabel.text = ""
      cell.valueLabel.text = ""
    } else {
      let item = itemStore.allItems[indexPath.row]
      cell.nameLabel.text = item.name
      cell.serialNumberLabel.text = item.serialNumber
      cell.valueLabel.text = "$\(item.valueInDollars)"
      cell.updateValueLabelColor()
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
    return "Remove"
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      let item = itemStore.allItems[indexPath.row]
      
      let title = "Delete \(item.name)?"
      let message = "Are you sure you want to delete this item?"
      let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      ac.addAction(cancelAction)
      
      let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { [unowned self] (action) in
        self.itemStore.removeItem(item)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      })
      ac.addAction(deleteAction)
      
      presentViewController(ac, animated: true, completion: nil)
    }
  }
  
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return itemStore.allItems.count != 0 && indexPath.row < itemStore.allItems.count
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return itemStore.allItems.count != 0 && indexPath.row < itemStore.allItems.count
  }
  
  override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    if destinationIndexPath.row < itemStore.allItems.count {
      itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
  }

  override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
    if proposedDestinationIndexPath.row >= itemStore.allItems.count {
      return NSIndexPath(forRow: itemStore.allItems.count-1, inSection: 0)
    } else {
      return proposedDestinationIndexPath
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowItem" {
      if let row = tableView.indexPathForSelectedRow?.row {
        let item = itemStore.allItems[row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.item = item
      }
    }
  }
}
