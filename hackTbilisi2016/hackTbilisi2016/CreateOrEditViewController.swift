import UIKit
import Parse

class CreateOrEditViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var imageWrapper: UIView!
    @IBOutlet weak var removeButton: UIButton!
    weak var delegate: CreateOrEditDelegate?
    var model: FeedModel?
    let images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.delegate = self
        addTopBorder()
        removeButton.layer.cornerRadius = removeButton.frame.width * 0.1
    }

    override func viewDidAppear(animated: Bool) {
        if let model = model {
            inputTextView.text = model.text
            for image in model.images {
                let index = Int("\(image[image.characters.count - 1])")!
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
                imageView.image = UIImage(named: "move\(index)")
                imageView.tag = index
                imageWrapper.addSubview(imageView)
                imageView.center = imageWrapper.center
                imageView.frame.origin.x = CGFloat((imageWrapper.subviews.count - 1) * 51)
            }
            removeButton.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func addTopBorder() {
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor(colorLiteralRed: 239/255, green: 239/255, blue: 244/255, alpha: 1).CGColor
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 2)
        imageWrapper.layer.addSublayer(topBorder)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // remove image from view
    @IBAction func removeLastImage(sender: UIButton) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let subViewSize = imageWrapper.subviews.count
        print(subViewSize)
        if subViewSize > 0 {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.imageWrapper.subviews.last!.frame.origin.x = self.imageWrapper.frame.width
                self.imageWrapper.subviews.last!.alpha = 0
                self.removeButton.hidden = false
                }) { (bool: Bool) -> Void in
                    self.imageWrapper.subviews.last!.removeFromSuperview()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
            
            removeButton.hidden = subViewSize == 1 ? true : false
        }
    }

    // add action image to view
    @IBAction func addActionImage(sender: UIBarButtonItem) {
        let subViewSize = imageWrapper.subviews.count
        if subViewSize < 5 {
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            let index = sender.tag
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.alpha = 0
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.image = UIImage(named: "move\(index)")
            imageView.tag = index
            let children = imageWrapper.subviews.count
            imageWrapper.addSubview(imageView)
            imageView.center = imageWrapper.center
            imageView.frame.origin.x = imageWrapper.frame.width
            
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                imageView.frame.origin.x = CGFloat(children * 51)
                imageView.alpha = 1
                self.removeButton.hidden = false
                }) { (bool: Bool) -> Void in
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        }
    }
    
    // try save stuff or edit
    @IBAction func Save(sender: UIBarButtonItem) {
        if inputTextView.text.isEmpty {
            alertError("Please fill text field")
        }
        else if imageWrapper.subviews.count == 0 {
            alertError("Please choose one of the actions down below")
        }
        else {
            let model = FeedModel(id: self.model?.id, text: inputTextView.text, images: imageWrapper.subviews.map { "move\($0.tag)" })
            
            // prevent same records
            let query = PFQuery(className: "Feed")
            query.fromLocalDatastore()
            query.whereKey("isActive", equalTo: true)
            if let id = model.id {
               query.whereKey("id", notEqualTo: id)
            }
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects {
                        let isValid = objects.filter {
                            ($0.objectForKey("actions") as! [String]).joinWithSeparator(",") == model.images.joinWithSeparator(",")
                            }.count == 0
                        if isValid {
                            self.delegate!.CreateOrEditDidFinish(self, model: model)
                        }
                        else {
                            self.alertError("Combinations exists")
                        }
                    }
                }
            }
        }
    }
    
    // alert error message
    private func alertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
