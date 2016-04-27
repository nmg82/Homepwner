import UIKit

class CustomTextField: UITextField {
  override func becomeFirstResponder() -> Bool {
    borderStyle = .Bezel
    return super.becomeFirstResponder()
  }
  
  override func resignFirstResponder() -> Bool {
    borderStyle = .RoundedRect
    return super.resignFirstResponder()
  }
}