//
//  ViewController.swift
//  Chop-Chop
//
//  Created by Seulmin Andy Ryu on 4/13/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseUI
import FirebaseFirestore
import SwiftyJSON
import Alamofire

var jsonRecipes = Recipes2.recipes
var jsonArray = [JSON]();

class ViewController: UIViewController {
    
    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var viewForLayer: UIView!
    var gradientLayer: CAGradientLayer!
    var blueColor = UIColor(red:0.0, green: (228/255), blue:1.0, alpha: 0.5 )
    var greenColor = UIColor(red:(105/255), green: (255/255), blue: (151/255), alpha: 0.5)
    
    var x = 0
    var y = -30
    var w = 414
    var h = 300
    
//    var screenWidth = UIScreen.main.bounds.width
//    var screenHeight = UIScreen.main.bounds.height

    
    @IBOutlet weak var GButton: UIButton!
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
//        gradientLayer.cornerRadius = 50.0
        gradientLayer.frame = self.view.bounds
        self.gradientLayer.locations = [0.0, 1.0]
        
        gradientLayer.colors = [blueColor.cgColor, greenColor.cgColor]
        gradientLayer.zPosition = -2;
        self.view.layer.addSublayer(gradientLayer)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getJokeRequest()
//        let mainPage = self.storyboard!.instantiateViewController(withIdentifier: "Start") as! UIViewController
//        
//        UIApplication
//        
//        self.window?.rootViewController = mainPage
//        self.window?.makeKeyAndVisible()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()

        let gSignIn = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 230, height: 48))
            gSignIn.center = view.center
            view.addSubview(gSignIn)
        
        //Pulling recipes from database
        let db = Firestore.firestore();
        
        db.collection("items").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")                    
                    jsonRecipes.append(document.data())
                }
                for (index, _) in jsonRecipes.enumerated() {
                    let json = JSON(jsonRecipes[index])
                    jsonArray.append(json)
                    
                    
                }
//                print((recipes[2]))
            }
        }
        
//       db.collection("userData").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    //print("\(document.documentID) => \(document.data())")
//                    //print(document.data())
//                    let json = JSON(document.data())
//                    //print(json["id"])
//                    if(json["id"].stringValue == userToken) {
//                        let len = json["ingredients"].count
//                        for i in 0...(len-1) {
//                            Input.allInputs.append(json["ingredients"][i].stringValue)
//                        }
//                    }
//                }
//            }
//        }
    }
    

    
    //Sign out function we can use later on
    //Do something like UIButton.addTarget(self, action: #selector(self.signOut(_:)), for: .touchUpInside)
    //Referenced https://www.youtube.com/watch?v=BjsJNpgsl5c
    @objc func signOut(_ sender: UIButton) {
        print("Signing Out")
        GIDSignIn.sharedInstance().signOut()
    }
    
    func login() {
        self.performSegue(withIdentifier: "toStart", sender: nil)
    }
    
    func getJokeRequest() {
        let url = "https://api.spoonacular.com/food/jokes/random?apiKey=7416dc48fba247819ce90cd88a3974ec"
        
        let requestURL = url
        print(requestURL)
        
        AF.request(requestURL, method: .get, encoding:JSONEncoding.default).responseData { response in
            guard let data = response.data else {return}
            let json = try? JSON(data: data)
            let stringJSON = json!["text"].stringValue
            
            //print(stringJSON)
            self.jokeLabel.text = stringJSON
            
        }
    }
}

