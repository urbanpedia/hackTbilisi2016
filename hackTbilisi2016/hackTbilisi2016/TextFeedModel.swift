import Foundation

class FeedModel {
    var text: String
    var images: [String]
    
    init(text: String, images: [String]) {
        self.text = text
        self.images = images
    }
}

