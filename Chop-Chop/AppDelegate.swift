//
//  AppDelegate.swift
//  Chop-Chop
//
//  Created by Seulmin Andy Ryu on 4/13/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import Firebase
import FirebaseUI
import FirebaseFirestore

var userToken = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        print("here")
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
//        UINavigationBar.appearance().barTintColor = UIColor.yellow;
//        UINavigationBar.appearance().tintColor = UIColor.orange;
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        GIDSignIn.sharedInstance().delegate = self
        if (GIDSignIn.sharedInstance()?.hasPreviousSignIn())! {
            login()
        }
        else {
        /* code to show your login VC */
        }
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    //When someone signs into google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        }
        else {
          print("\(error.localizedDescription)")
        }
        return
      }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let err = error {
                print("failed ", err)
                return
            }
            guard let uid = authResult?.user else {return}
            print("logged in", uid)
            self.login()
        }
        
        
        
      // Perform any operations on signed in user here.
      let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken! // Safe to send to the server
        
      let fullName = user.profile.name
      let givenName = user.profile.givenName
      let familyName = user.profile.familyName
      let email = user.profile.email
        userToken = String(email!)
        if user.profile.hasImage{
            let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 120)
            print(" image url: ", imageUrl?.absoluteString)
        }
    
      print("Full name:", fullName)
        
        //Pull UPC Code from API, and store them in ProductCatalog.plist
        
    }
    
    
    //When user disconnects from the app
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      print("User has disconnected")
    }
    
    
    func login () {
//        self.window = UIWindow(frame: UIScreen.main.bounds);
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainPage = storyboard.instantiateViewController(withIdentifier: "Start")
//        self.window?.rootViewController = mainPage
//        self.window?.makeKeyAndVisible()
//        print("login page change")
        if let vc = GIDSignIn.sharedInstance()?.presentingViewController {
            let signinVC = vc as! ViewController
            
            signinVC.login()
        }
    }



    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Chop_Chop")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    

}

