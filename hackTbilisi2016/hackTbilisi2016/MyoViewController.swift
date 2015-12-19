import UIKit
import Parse
import AVFoundation

class MyoViewController: UIViewController {
    
    @IBOutlet weak var imageWrapper: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        backgroundImage.addSubview(blurEffectView)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didConnectDevice:",
            name: TLMHubDidConnectDeviceNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didDisconnectDevice:",
            name: TLMHubDidDisconnectDeviceNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didSyncArm:",
            name: TLMMyoDidReceiveArmSyncEventNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didUnsyncArm:",
            name: TLMMyoDidReceiveArmUnsyncEventNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didUnlockDevice:",
            name: TLMMyoDidReceiveUnlockEventNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didLockDevice:",
            name: TLMMyoDidReceiveLockEventNotification,
            object: nil)
        
        //        NSNotificationCenter.defaultCenter().addObserver(
        //            self,
        //            selector: "didReceiveOrientationEvent:",
        //            name: TLMMyoDidReceiveOrientationEventNotification,
        //            object: nil)
        //
        //        NSNotificationCenter.defaultCenter().addObserver(
        //            self,
        //            selector: "didReceiveAccelerometerEvent:",
        //            name: TLMMyoDidReceiveAccelerometerEventNotification,
        //            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didReceivePoseChange:",
            name: TLMMyoDidReceivePoseChangedNotification,
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        textToSpeach("this is awesome")
    }
    
    @IBAction func goToSettings(sender: UIBarButtonItem) {
        let controller = TLMSettingsViewController.settingsInNavigationController()
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func didConnectDevice(notification: NSNotification) {
        //print(notification.userInfo![kTLMKeyMyo])
        
        // Set the text of the armLabel to "Perform the Sync Gesture".
//        self.textLable.text = "Perform the Sync Gesture";
//        
//        // Set the text of our helloLabel to be "Hello Myo".
//        self.mainText.text = "Hello Myo";
    }
    
    func didDisconnectDevice(notification: NSNotification) {
        //print(notification.userInfo![kTLMKeyMyo])
        // Set the text of the armLabel to "Perform the Sync Gesture".
//        self.textLable.text = "Perform the Sync Gesture";
//        
//        // Set the text of our helloLabel to be "Hello Myo".
//        self.mainText.text = "Hello Myo";
    }
    
    func didSyncArm(notification: NSNotification) {
//        self.textLable.text = "Perform the Sync Gesture";
//        self.mainText.text = "Hello Myo";
//        let armEvent = notification.userInfo![kTLMKeyArmSyncEvent]
//        //let armString = armEvent!.arm == TLMArm.Right ? "Right" : "Left";
//        let directionString = armEvent!.xDirection == TLMArmXDirection.TowardWrist ? "Toward Wrist" : "Toward Elbow";
//        self.mainText.text = directionString
    }
    
    func didUnsyncArm(notification: NSNotification) {
        //print(notification.userInfo![kTLMKeyMyo])
        // Set the text of the armLabel to "Perform the Sync Gesture".
//        self.textLable.text = "Perform the Sync Gesture";
//        
//        // Set the text of our helloLabel to be "Hello Myo".
//        self.mainText.text = "Hello Myo";
    }
    
    func didUnlockDevice(notification: NSNotification) {
        print("unlocke")
    }
    
    func didlockDevice(notification: NSNotification) {
        print("locke")
    }
    
    func didReceiveOrientationEvent(notification: NSNotification) {
        //print(notification.userInfo![kTLMKeyOrientationEvent])
    }
    
    func didReceiveAccelerometerEvent(notification: NSNotification) {
        //print(notification.userInfo![kTLMKeyAccelerometerEvent])
        
//        let accelerometerEvent = notification.userInfo![kTLMKeyAccelerometerEvent]!
//        
//        // Get the acceleration vector from the accelerometer event.
//        let accelerationVector = accelerometerEvent.vector;
//        
//        // Calculate the magnitude of the acceleration vector.
//        let magnitude = TLMVector3Length(accelerationVector);
//        
//        // Update the progress bar based on the magnitude of the acceleration vector.
//        self.progressbar.progress = magnitude / 8;
    }
    
    var actions = [Int]()
    var isLocked = false
    func didReceivePoseChange(notification: NSNotification) {
        let pose = notification.userInfo![kTLMKeyPose]!
        var sensor = ""
        var tag = 0
        
        if isLocked == true {
            return
        }
        else {
            print("not locked")
        }
        
        if pose.type == TLMPoseType.Fist {
            sensor = "Fist"
            tag = 1
        }
        else if pose.type == TLMPoseType.FingersSpread {
            sensor = "FingersSpread"
            tag = 2
        }
        else if pose.type == TLMPoseType.WaveOut {
            sensor = "WaveOut"
            tag = 3
        }
        else if pose.type == TLMPoseType.WaveIn {
            sensor = "WaveIn"
            tag = 4
        }
        else {
            if pose.type == TLMPoseType.DoubleTap {
                sensor = "DoubleTap"
                findTextOnActions(actions.map { "move\($0)" })
                print(actions)
                actions.removeAll()
                clearSubViews(imageWrapper)
            }
            else if pose.type == TLMPoseType.Rest {
                sensor = "Rest"
            }
            
            return
        }
        
        actions.append(tag)
        addActionImage(tag)
        print(sensor)
    }
    
    private func clearSubViews(view: UIView) {
        for subView in view.subviews {
            subView.removeFromSuperview()
        }
    }
    
    private func textToSpeach(text: String) {
        print(text)
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for voice in voices {
            if "en-US" == voice.language {
                myUtterance.voice = voice
                print(voice.language)
                break;
            }
        }
        myUtterance = AVSpeechUtterance(string: text)
        myUtterance.rate = 0.5
        synth.speakUtterance(myUtterance)
    }
    
    private func findTextOnActions(actions: [String]) {
        let query = PFQuery(className: "Feed")
        query.fromLocalDatastore()
        query.whereKey("isActive", equalTo: true)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    let text = objects.filter {
                        ($0.objectForKey("actions") as! [String]).joinWithSeparator(",") == actions.joinWithSeparator(",")
                    }.first?.objectForKey("text") as? String
                    self.textToSpeach(text == nil ? "" : text!)
                }
            }
            self.isLocked = false
        }
    }
    
    private func addActionImage(tag: Int) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let index = tag
        let width = 60
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        imageView.frame.origin.y = imageWrapper.frame.height / 2 - CGFloat(width / 2)
        imageView.alpha = 0
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = UIImage(named: "move\(index)")
        imageView.tag = index
        let children = imageWrapper.subviews.count
        imageWrapper.addSubview(imageView)
        imageView.frame.origin.x = imageWrapper.frame.width
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            imageView.frame.origin.x = CGFloat(children * (width + 1))
            imageView.alpha = 1
            }) { (bool: Bool) -> Void in
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
}
