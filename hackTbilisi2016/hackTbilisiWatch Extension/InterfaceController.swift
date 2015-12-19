import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    var wcSession: WCSession!
    
    @IBOutlet var speechTextLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        initialWCSession()
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
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
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print(message)
        speechTextLabel.setText(message["message"] as? String)
        replyHandler(["string": ["awd"]])
    }
    
    @IBAction func goToSuggestions() {
        self.presentTextInputControllerWithSuggestions(
            ["Thank you my dear", "You are awsome", "This is the best day"],
            allowedInputMode: WKTextInputMode.Plain) { (objects: [AnyObject]?) -> Void in
            if let objects = objects {
                if let answer = objects[0] as? String {
                    print("\(answer)")
                }
            }
        }
    }
}
