import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var nameField: UITextField!
  @IBOutlet var serialNumberField: UITextField!
  @IBOutlet var valueField: UITextField!
  @IBOutlet var dateLabel: UILabel!
  
  var item: Item! {
    didSet {
      navigationItem.title = item.name
    }
  }
  
  let numberFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
  let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .NoStyle
    return formatter
  }()
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    nameField.text = item.name
    serialNumberField.text = item.serialNumber
    valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
    dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    view.endEditing(true)
    
    item.name = nameField.text ?? ""
    item.serialNumber = serialNumberField.text
    
    guard let valueText = valueField.text, value = numberFormatter.numberFromString(valueText) else {
      item.valueInDollars = 0
      return
    }
    
    item.valueInDollars = value.integerValue
  }
  
  @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ChangeDate" {
      let changeDateViewController = segue.destinationViewController as! ChangeDateViewController
      changeDateViewController.item = item
    }
  }
}

extension DetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}
