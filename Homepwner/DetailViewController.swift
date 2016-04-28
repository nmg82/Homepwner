import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var nameField: UITextField!
  @IBOutlet var serialNumberField: UITextField!
  @IBOutlet var valueField: UITextField!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var deleteImageButton: UIButton!
  
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
    
    if imageView.image == nil {
      toggleDeleteImageButton()
    }
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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ChangeDate" {
      let changeDateViewController = segue.destinationViewController as! ChangeDateViewController
      changeDateViewController.item = item
    }
  }
  
  @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
    view.endEditing(true)
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
    
    let overlayView = UIImageView(image: UIImage(named: "crosshair"))
    overlayView.frame = imagePicker.cameraOverlayView!.frame
    overlayView.contentMode = .Center
    overlayView.center.y -= 40
    imagePicker.cameraOverlayView = overlayView
    
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func deleteImage(sender: UIButton) {
    let alertController = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: .ActionSheet)
    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    alertController.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { [unowned self] (_) in
      self.imageStore.deleteImageForKey(self.item.itemKey)
      self.imageView.image = nil
      self.toggleDeleteImageButton()
    }))
    
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  private func toggleDeleteImageButton() {
    deleteImageButton.hidden = !deleteImageButton.hidden
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
    toggleDeleteImageButton()
    
    dismissViewControllerAnimated(true, completion: nil)
  }
}
