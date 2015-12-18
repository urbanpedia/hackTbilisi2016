import UIKit

class TextFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var model = [FeedModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.append(FeedModel(text: "application, you will often want to do", images: ["mov1_black", "mov2_black", "mov3_black"]))
        model.append(FeedModel(text: "application, you will often want to do", images: ["mov1_black", "mov3_black"]))
        model.append(FeedModel(text: "application, you will often want to do", images: ["mov1_black", "mov2_black"]))
        model.append(FeedModel(text: "application, you will often want to do", images: ["mov1_black", "mov4_black", "mov1_black"]))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCellWithIdentifier("myoRow", forIndexPath: indexPath) as!
        TextFeedTableViewCell
        row.feedLabel.text = "application, you will often want to do"
        for subview in row.imageWrapper.subviews {
            subview.removeFromSuperview()
        }
        
        // draw images
        for (index, image) in model[indexPath.row].images.enumerate() {
            let imageView = UIImageView(frame: CGRect(x: index * 31, y: 0, width: 30, height: 30))
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.image = UIImage(named: image)!
            row.imageWrapper.addSubview(imageView)
        }
        
        return row
    }
    
    @IBAction func GoToCreate(sender: UIBarButtonItem) {
        performSegueWithIdentifier("create", sender: self)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "create" {
            let controller = segue.destinationViewController as! CreateOrEditViewController
        }
    }
}
