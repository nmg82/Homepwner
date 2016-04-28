import UIKit

class Item: NSObject, NSCoding {
  var name: String
  var valueInDollars: Int
  var serialNumber: String?
  var dateCreated: NSDate
  var itemKey: String
  
  init(name: String, serialNumber: String?, valueInDollars: Int, dateCreated: NSDate = NSDate()) {
    self.name = name
    self.valueInDollars = valueInDollars
    self.serialNumber = serialNumber
    self.dateCreated = dateCreated
    self.itemKey = NSUUID().UUIDString
    super.init()
  }
  
  convenience init(random: Bool = false) {
    if random {
      let adjectives = ["Fluffy", "Rusty", "Shiny"]
      let nouns = ["Bear", "Spork", "Mac"]
      
      var idx = arc4random_uniform(UInt32(adjectives.count))
      let randomAdjective = adjectives[Int(idx)]
      
      idx = arc4random_uniform(UInt32(nouns.count))
      let randomNoun = nouns[Int(idx)]
      
      let randomName = "\(randomAdjective) \(randomNoun)"
      let randomValue = Int(arc4random_uniform(100))
      let randomSerialNumber = NSUUID().UUIDString.componentsSeparatedByString("-").first!
      
      self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
    } else {
      self.init(name: "", serialNumber: nil, valueInDollars: 0)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObjectForKey("name") as! String
    valueInDollars = aDecoder.decodeIntegerForKey("valueInDollars")
    serialNumber = aDecoder.decodeObjectForKey("serialNumber") as! String?
    dateCreated = aDecoder.decodeObjectForKey("dateCreated") as! NSDate
    itemKey = aDecoder.decodeObjectForKey("itemKey") as! String
    
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(name, forKey: "name")
    aCoder.encodeInteger(valueInDollars, forKey: "valueInDollars")
    aCoder.encodeObject(serialNumber, forKey: "serialNumber")
    aCoder.encodeObject(dateCreated, forKey: "dateCreated")
    aCoder.encodeObject(itemKey, forKey: "itemKey")
  }
}
