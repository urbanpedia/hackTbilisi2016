import UIKit
import Parse
import WatchConnectivity

protocol CreateOrEditDelegate: class {
    func CreateOrEditDidFinish(controller: CreateOrEditViewController, model: FeedModel)
}

class TextFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateOrEditDelegate, WCSessionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var model = [FeedModel]()
    var wcSession: WCSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initialWCSession()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "db_tap")!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .Stretch), forBarMetrics: .Default)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "mov4_white")
        imageView.image = image
        navigationItem.titleView = imageView

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initialWCSession() {
        if WCSession.isSupported() {
            wcSession = WCSession.defaultSession()
            wcSession.delegate = self
            wcSession.activateSession()
        }
        else {
            print("installed")
        }
        
        sendMessageToWC()
    }
    
    private func sendMessageToWC() {
        wcSession.sendMessage(["message" : "text to displey"],
            replyHandler: { (data: [String : AnyObject]) -> Void in
                print("done message sending")
            }) { (error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
    private func loadData() {
        let query = PFQuery(className: "Feed")
        query.fromLocalDatastore()
        query.whereKey("isActive", equalTo: true)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        print(object.objectForKey("id")!)
                        print(object.objectForKey("text")!)
                        print(object.objectForKey("actions")!)
                        print(object.objectForKey("isActive")!)
                        let modelItem = FeedModel(
                            id: object.objectForKey("id") as? String,
                            text: object.objectForKey("text") as! String,
                            images: object.objectForKey("actions") as! [String])
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
        row.imageWrapper.removeAllSubviews()
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
            deleteRecord(id)
        }
    }
    
    private func deleteRecord(id: String) {
        let query = PFQuery(className: "Feed")
        query.fromLocalDatastore()
        query.whereKey("id", equalTo: id)
        query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects {
                for object in objects {
                    object.setValue(false, forKey: "isActive")
                    object.pinInBackground()
                }
            }
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("edit", sender: self)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath
            )
            return
        })
        
        deleteButton.backgroundColor = self.navigationController!.navigationBar.barTintColor!
        
        return [deleteButton]
    }
    
    @IBAction func goToCreate(sender: UIBarButtonItem) {
        performSegueWithIdentifier("create", sender: self)
    }
    
    @IBAction func goToMyo(sender: UIBarButtonItem) {
        performSegueWithIdentifier("myo", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myo" {
            _ = segue.destinationViewController as! MyoViewController
        }
        else {
            let controller = segue.destinationViewController as! CreateOrEditViewController
            controller.delegate = self
            if segue.identifier == "edit" {
                controller.model = model[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func CreateOrEditDidFinish(controller: CreateOrEditViewController, model: FeedModel) {
        if let id = model.id {
            let query = PFQuery(className: "Feed")
            query.fromLocalDatastore()
            query.whereKey("id", equalTo: id)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if let objects = objects {
                    for object in objects {
                        object.setValue(model.text, forKey: "text")
                        object.setValue(model.images, forKey: "actions")
                        object.pinInBackground()
                    }
                }
            })
            let index = self.model.indexOf{ $0.id == id }!
            self.model[index] = model
        }
        else {
            let id = RandomStringHelper.getRandomString()
            let feed = PFObject(className: "Feed")
            feed["id"] = id
            feed["text"] = model.text
            feed["actions"] = model.images
            feed["isActive"] = true
            feed.pinInBackground()
            model.id = id
            self.model.insert(model, atIndex: 0)
        }

        self.tableView.reloadData()
        self.navigationController!.popViewControllerAnimated(true)
    }
}
