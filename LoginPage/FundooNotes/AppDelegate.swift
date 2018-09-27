 import UIKit
import CoreData
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.object(forKey: "userId") != nil{
            self.loginUser()
        }else{
        }
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func loginUser(){
        let stroryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stroryBoard.instantiateViewController(withIdentifier: "DashboardContainerViewController") as! DashboardContainerViewController
        window?.rootViewController = vc
    }
    func switchRootViewController(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "main") as? LoginViewController
        
        self.window?.rootViewController = nav
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDBManager.saveContext()
        switchRootViewController()
    }
}
