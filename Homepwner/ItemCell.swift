import UIKit

class ItemCell: UITableViewCell {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var serialNumberLabel: UILabel!
  @IBOutlet var valueLabel: UILabel!
  
  func updateLabels() {
    let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    nameLabel.font = bodyFont
    valueLabel.font = bodyFont
    
    let caption1Font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    serialNumberLabel.font = caption1Font
  }
  
  func updateValueLabelColor() {
    guard let beginIndex = valueLabel.text?.startIndex.advancedBy(1),
      valueString = valueLabel.text?.substringFromIndex(beginIndex),
      value = Int(valueString) else { return }
    
    if value < 50 {
      valueLabel.textColor = UIColor.greenColor()
    }
    
    if value >= 50 {
      valueLabel.textColor = UIColor.redColor()
    }
  }
}