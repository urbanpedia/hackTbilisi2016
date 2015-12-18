import UIKit
import Parse

class CreateOrEditViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var imageWrapper: UIView!
    @IBOutlet weak var removeButton: UIButton!
    weak var delegate: CreateOrEditDelegate?
    let images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.delegate = self
        addTopBorder()
        removeButton.layer.cornerRadius = removeButton.frame.width * 0.1
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
    
    @IBAction func removeLastImage(sender: UIButton) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let subViewSize = imageWrapper.subviews.count
        if subViewSize > 0 {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.imageWrapper.subviews[subViewSize - 1].frame.origin.x = self.imageWrapper.frame.width
                self.imageWrapper.subviews[subViewSize - 1].alpha = 0
                self.removeButton.hidden = false
                }) { (bool: Bool) -> Void in
                    self.imageWrapper.subviews[subViewSize - 1].removeFromSuperview()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
            
            if subViewSize == 1 {
                removeButton.hidden = true
            }
        }
    }
    
    
    @IBAction func addActionImage(sender: UIBarButtonItem) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let index = sender.tag
        let imageView = UIImageView(frame: CGRect(x: imageWrapper.frame.width, y: 0, width: 50, height: 50))
        imageView.frame.origin.y = imageWrapper.frame.height / 2 - 20
        imageView.alpha = 0
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = UIImage(named: "move\(index)")
        imageView.tag = index
        let children = imageWrapper.subviews.count
        imageWrapper.addSubview(imageView)
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                imageView.frame.origin.x = CGFloat(children * 51)
                imageView.alpha = 1
                self.removeButton.hidden = false
            }) { (bool: Bool) -> Void in
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    @IBAction func Save(sender: UIBarButtonItem) {
        if inputTextView.text.isEmpty {
            alertError("Please fill text field")
        }
        else if imageWrapper.subviews.count == 0 {
            alertError("Please choose one of the actions down below")
        }
        else {
            let model = FeedModel(id: nil, text: inputTextView.text, images: imageWrapper.subviews.map { "move\($0.tag)" })
            delegate!.CreateOrEditDidFinish(self, model: model)
        }
    }
    
    private func alertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
