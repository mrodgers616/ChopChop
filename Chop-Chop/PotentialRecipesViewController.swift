//
//  PotentialRecipesViewController.swift
//  Chop-Chop
//
//  Created by Seulmin Andy Ryu on 5/3/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

var allRecipes = [Recipe]()
class PotentialRecipesViewController: UIViewController {
    @IBOutlet weak var img1: UIButton!
    @IBOutlet weak var img2: UIButton!
    @IBOutlet weak var img3: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    override func loadView() {
        super.loadView()
        allRecipes.removeAll()
        idArray.removeAll()
        urlArray.removeAll()
        nameArray.removeAll()

        print("hellllo", Input.allInputs)
        
        //MARK: Implement matching algorithm
        for recipe in jsonArray {
            var string = ""
            let name = recipe["name"].stringValue
            var allOriginalStrings = ""
            
            for ingredient in recipe["missedIngredients"] {
                let json = JSON(ingredient.1)
                string += json["name"].stringValue.lowercased() + ", "
                allOriginalStrings += json["originalString"].stringValue + ", "
            }
            
            for ingredient in recipe["usedIngredients"] {
                let json = JSON(ingredient.1)
                string += json["name"].stringValue.lowercased() + ", "
                allOriginalStrings += json["originalString"].stringValue + ", "
            }
            
            var counter = 0
            for ingredient in Input.allInputs {
                if (string.contains(ingredient.lowercased())) {
                   counter += 1
               }
            }
            
            let current = Recipe(name:name, originalString:allOriginalStrings, image:recipe["image"].stringValue, ingredients:string, count: counter, id: recipe["id"].stringValue)
            allRecipes.append(current)
        }
            
        //Connect them back to the view controller, make a table view of all the recipes
        var array = allRecipes.sorted {  $0.count < $1.count }
        array = array.reversed()
        
        idArray.append(array[0].id)
        idArray.append(array[1].id)
        idArray.append(array[2].id)
        
        urlArray.append(array[0].image)
        urlArray.append(array[1].image)
        urlArray.append(array[2].image)
        
        nameArray.append(array[0].name)
        nameArray.append(array[1].name)
        nameArray.append(array[2].name)


        if let url = URL(string:array[0].image) {
            do {
                let data = try Data(contentsOf: url)
//                self.img1.setImage(UIImage(data:data), for: .normal)
                self.img1.setBackgroundImage(UIImage(data:data), for: .normal)
                self.label1.text = array[0].name
            }
            catch let err {
                print("error", err)
            }
        }
        if let url = URL(string:array[1].image) {
            do {
                let data = try Data(contentsOf: url)
                self.img2.setBackgroundImage(UIImage(data:data), for: .normal)
                self.label2.text = array[1].name
            }
            catch let err {
                print("error", err)
            }
        }
        if let url = URL(string:array[2].image) {
            do {
                let data = try Data(contentsOf: url)
                self.img3.setBackgroundImage(UIImage(data:data), for: .normal)
                self.label3.text = array[2].name
            }
            catch let err {
                print("error", err)
            }
        }
    }
    @IBAction func img1Click(_ sender: Any) {
        recipeID = idArray[0]
        recipeImage = urlArray[0]
        recipeName = nameArray[0]
        newStoryboard()
    }
    @IBAction func img2Click(_ sender: Any) {
        recipeID = idArray[1]
        recipeImage = urlArray[1]
        recipeName = nameArray[1]
        newStoryboard()
    }
    @IBAction func img3Click(_ sender: Any) {
        recipeID = idArray[2]
        recipeImage = urlArray[2]
        recipeName = nameArray[2]
        newStoryboard()
    }
    func newStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let nav = storyboard.instantiateViewController(withIdentifier: "specificRecipe") as! UINavigationController
        let vc = storyboard.instantiateViewController(withIdentifier: "exploreSpecific")
        nav.pushViewController(vc, animated: true)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil);
    }
}
