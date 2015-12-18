import UIKit

class CreateOrEditViewController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var imageWrapper: UIView!
    let images = ["mov1_black", "mov2_black", "mov3_black", "mov4_black"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func Save(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addActionImage(sender: UIBarButtonItem) {
        let index = sender.tag
        let imageView = UIImageView(frame: CGRect(x: imageWrapper.frame.width, y: 0, width: 50, height: 50))
            imageView.frame.origin.y = imageWrapper.frame.height / 2 - 20
            print(imageWrapper.frame)
//        imageView.alpha = 0
//        imageView.center = imageWrapper.center
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = UIImage(named: images[index])
        let children = imageWrapper.subviews.count
        imageWrapper.addSubview(imageView)
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                imageView.frame.origin.x = CGFloat(children * 51)
                imageView.alpha = 1
            }) { (bool: Bool) -> Void in
        }
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
