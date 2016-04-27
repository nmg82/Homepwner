import UIKit

class ChangeDateViewController: UIViewController {
  @IBOutlet var dateCreatedLabel: UILabel!
  @IBOutlet var datePicker: UIDatePicker!
  
  let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .NoStyle
    return formatter
  }()
  
  var item: Item! {
    didSet {
      navigationItem.title = item.name
    }
  }
  
  override func viewDidLoad() {
    dateCreatedLabel.text = dateFormatter.stringFromDate(item.dateCreated)
    datePicker.date = item.dateCreated
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    item.dateCreated = datePicker.date
  }
  
  @IBAction func datePickerValueChanged() {
    dateCreatedLabel.text = dateFormatter.stringFromDate(datePicker.date)
  }
}