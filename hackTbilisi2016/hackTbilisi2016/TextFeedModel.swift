import Foundation

class FeedModel {
    var id: String?
    var text: String
    var images: [String]
    
    init(id: String?, text: String, images: [String]) {
        self.id = id
        self.text = text
        self.images = images
    }
}

