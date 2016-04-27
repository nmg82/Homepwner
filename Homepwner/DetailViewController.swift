import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var nameField: UITextField!
  @IBOutlet var serialNumberField: UITextField!
  @IBOutlet var valueField: UITextField!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  
  var item: Item! {
    didSet {
      navigationItem.title = item.name
    }
  }
  
  var imageStore: ImageStore!
  
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
    imageView.image = imageStore.imageForKey(item.itemKey)
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
  
  @IBAction func takePicture(sender: UIBarButtonItem) {
    let imagePicker = UIImagePickerController()
    
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      imagePicker.sourceType = .Camera
    } else {
      imagePicker.sourceType = .PhotoLibrary
    }
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    
    presentViewController(imagePicker, animated: true, completion: nil)
  }
}

extension DetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    var selectedImage: UIImage
    
    if let editingInfo = editingInfo, editedImage = editingInfo[UIImagePickerControllerEditedImage] as? UIImage {
      selectedImage = editedImage
    } else {
      selectedImage = image
    }
    
    imageStore.setImage(selectedImage, forKey: item.itemKey)
    imageView.image = selectedImage
    
    dismissViewControllerAnimated(true, completion: nil)
  }
}
