import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // myo setup
        TLMHub.sharedHub()
        TLMHub.sharedHub().lockingPolicy = TLMLockingPolicy.None
        // parse setup
        Parse.enableLocalDatastore()
        Parse.setApplicationId("SIGglSWAFukWaevXlp1LPyKd95UELixAaTTkdXks",
            clientKey: "YgRIZIL992PWQM8k5GOFlvew0aXOM4ePJu99pjm2")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

