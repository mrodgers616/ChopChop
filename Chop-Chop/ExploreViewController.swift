//
//  ExploreViewController.swift
//  Chop-Chop
//
//  Created by Seulmin Andy Ryu on 5/4/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import UIKit
import GoogleSignIn
import SwiftyJSON
import Alamofire

//Global Variables
var recipeID = ""
var recipeImage = ""
var recipeName = ""
var idArray = [String]()
var urlArray = [String]()
var indexArray = [Int]()

var nameArray = [String]()
var shouldLoad = true


class ExploreViewController: UIViewController {
    @IBOutlet weak var img1: UIButton!
    @IBOutlet weak var img2: UIButton!
    @IBOutlet weak var img3: UIButton!
    @IBOutlet weak var img4: UIButton!
    
    @IBOutlet weak var triviaLabel: UILabel!

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var refresh: UIButton!
    
    override func loadView() {
        super.loadView()
        getTriviaRequest()
        loadNewRecipes()
        display()
    }
    
    func loadNewRecipes() {
        let length = jsonArray.count
            // Choose 4 random recipes from the recipee in the database
            
            idArray.removeAll()
            urlArray.removeAll()
            indexArray.removeAll()
            nameArray.removeAll()
            
            
            var index1 = Int.random(in: 0 ..< length)
            indexArray.append(index1)
            
            var index2 = 0
            repeat {
                index2 = Int.random(in: 0 ..< length)
            } while indexArray.contains(index2)
            indexArray.append(index2)
            
            var index3 = 0
            repeat {
                index3 = Int.random(in: 0 ..< length)
            } while indexArray.contains(index3)
            indexArray.append(index3)
            
            var index4 = 0
            repeat {
                index4 = Int.random(in: 0 ..< length)
            } while indexArray.contains(index4)
            indexArray.append(index4)
                    
            
            for i in indexArray {
                let url = jsonArray[i]["image"].stringValue
                urlArray.append(url)
                
                let name = jsonArray[i]["name"].stringValue
                nameArray.append(name)
                
                let id = jsonArray[i]["id"].stringValue
                idArray.append(id)
            }
    }
        
    func display() {
        if let url = URL(string:urlArray[0]) {
            do {
                let data = try Data(contentsOf: url)
                self.img1.setImage(UIImage(data:data), for: .normal)
                self.label1.text = nameArray[0]
            }
            catch let err {
                print("error", err)
            }
        }
        
        if let url = URL(string:urlArray[1]) {
            do {
                let data = try Data(contentsOf: url)
                self.img2.setImage(UIImage(data:data), for: .normal)
                self.label2.text = nameArray[1]
            }
            catch let err {
                print("error", err)
            }
        }
        
        if let url = URL(string:urlArray[2]) {
            do {
                let data = try Data(contentsOf: url)
                self.img3.setImage(UIImage(data:data), for: .normal)
                self.label3.text = nameArray[2]
            }
            catch let err {
                print("error", err)
            }
        }
        
        if let url = URL(string:urlArray[3]) {
            do {
                let data = try Data(contentsOf: url)
                self.img4.setImage(UIImage(data:data), for: .normal)
                self.label4.text = nameArray[3]
            }
            catch let err {
                print("error", err)
            }
        }
        
        
        // IMPORTANT
        // Look below to see how to parse JSON
        
//        print(jsonArray[22]["name"])
//        print(jsonArray[22]["missedIngredients"][0]["name"])
//        print(jsonArray[22]["name"].stringValue)
        
        // or go here
        // https://github.com/SwiftyJSON/SwiftyJSON
        // For video tutorial
        // https://www.youtube.com/watch?v=Rqr3w8scm2E
    }
    
    @IBAction func logout(_ sender: Any) {
        print("Signing Out")
        GIDSignIn.sharedInstance().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "loginView") ; // MySecondSecreen the storyboard ID
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func img1Click(_ sender: Any) {
        print(idArray[0])
        recipeID = idArray[0]
        recipeImage = urlArray[0]
        recipeName = nameArray[0]
        newStoryboard()
    }
    @IBAction func img2Click(_ sender: Any) {
        print(idArray[1])
        recipeID = idArray[1]
        recipeImage = urlArray[1]
        recipeName = nameArray[1]
        newStoryboard()
    }
    @IBAction func img3Click(_ sender: Any) {
        print(idArray[2])
        recipeID = idArray[2]
        recipeImage = urlArray[2]
        recipeName = nameArray[2]
        newStoryboard()
    }
    @IBAction func img4Click(_ sender: Any) {
       print(idArray[3])
        recipeID = idArray[3]
        recipeImage = urlArray[3]
        recipeName = nameArray[3]
        newStoryboard()
    }
    @IBAction func refreshButton(_ sender: Any) {
        shouldLoad = true
        loadNewRecipes()
        display()
        getTriviaRequest()
        print("refreshed")
    }
    
    func newStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let nav = storyboard.instantiateViewController(withIdentifier: "specificRecipe") as! UINavigationController
        let vc = storyboard.instantiateViewController(withIdentifier: "exploreSpecific")
        nav.pushViewController(vc, animated: true)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil);
    }
    
    func getTriviaRequest() {
        let url = "https://api.spoonacular.com/food/trivia/random?apiKey=7416dc48fba247819ce90cd88a3974ec"
        
        let requestURL = url
        print(requestURL)
        
        AF.request(requestURL, method: .get, encoding:JSONEncoding.default).responseData { response in
            guard let data = response.data else {return}
            let json = try? JSON(data: data)
            let stringJSON = json!["text"].stringValue
            
            //print(stringJSON)
            self.triviaLabel.text = stringJSON
            
        }
    }
    
    
}
