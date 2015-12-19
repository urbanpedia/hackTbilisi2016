import Foundation

extension String {
    subscript (index: Int) -> Character {
        return self[self.startIndex.advancedBy(index)]
    }
}

class RandomStringHelper {
    
    static var length = 32
    static var source = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    static func getRandomString() -> String {
        var id = ""
        for _ in 1...length {
            let randomIndex = Int(arc4random_uniform(UInt32(source.characters.count)))
            id.append(source[randomIndex])
        }
        return id
    }
}