import UIKit
import Parse

protocol CreateOrEditDelegate: class {
    func CreateOrEditDidFinish(controller: CreateOrEditViewController, model: FeedModel)
}

class TextFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateOrEditDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var model = [FeedModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func loadData() {
        let query = PFQuery(className: "Feed")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
//                        print(object.objectForKey("text")!)
//                        print(object.objectForKey("actions")!)
                        let modelItem = FeedModel(id: object.objectId,text: object.objectForKey("text") as! String, images: object.objectForKey("actions") as! [String])
                        self.model.insert(modelItem, atIndex: 0)
                    }
                    self.tableView.reloadData()
                }
            }
        }
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
        row.feedLabel.text = model[indexPath.row].text
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let id = model[indexPath.row].id!
            model.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            let query = PFQuery(className: "Feed")
            query.fromLocalDatastore()
            query.getObjectInBackgroundWithId(id
                , block: { (object: PFObject?, error: NSError?) -> Void in
                    if let object = object, _ = error {
                        object.deleteInBackground()
                    }
            })
        }
    }
    
    @IBAction func GoToCreate(sender: UIBarButtonItem) {
        performSegueWithIdentifier("create", sender: self)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "create" {
            let controller = segue.destinationViewController as! CreateOrEditViewController
            controller.delegate = self
        }
    }
    
    func CreateOrEditDidFinish(controller: CreateOrEditViewController, model: FeedModel) {
        let feed = PFObject(className: "Feed")
        feed["text"] = model.text
        feed["actions"] = model.images
        feed.pinInBackgroundWithBlock { (bool: Bool, error: NSError?) -> Void in
            if error == nil {
                model.id = feed.objectId
                self.model.insert(model, atIndex: 0)
                self.tableView.reloadData()
                self.navigationController!.popViewControllerAnimated(true)
            }
        }
    }
}
