//
//  ExploreSpecificController.swift
//  Chop-Chop
//
//  Created by Matthew Rodgers on 5/6/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Firebase
import FirebaseUI
import FirebaseFirestore


class ExploreSpecificController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipeRequest(idOfRecipe: recipeID)
        nameLabel.text = recipeName
        if let url = URL(string:recipeImage) {
            do {
                let data = try Data(contentsOf: url)
                self.img.image = UIImage(data:data)
                
                //self.label1.text = nameArray[0]
            }
            catch let err {
                print("error", err)
            }
        }
        saveButton.setImage(UIImage(systemName: "checkmark.circle.fill"),
        for: [.highlighted, .selected])
        
        for recipe in savedRecipeArray {
            names.append(recipe.name)
        }
        
        if (names.contains(recipeName)) {
            saveButton.isSelected = true
        }
    }
    
    func getRecipeRequest(idOfRecipe: String) {
        let url = "https://api.spoonacular.com/recipes/"
        let url2 = "/summary?apiKey=7416dc48fba247819ce90cd88a3974ec"
        let id = idOfRecipe
        
        let requestURL = url + id + url2
        print(requestURL)
        
        AF.request(requestURL, method: .get, encoding:JSONEncoding.default).responseData { response in
            guard let data = response.data else {return}
            let json = try? JSON(data: data)
            let stringJSON = json!["summary"].stringValue
            
            let str = stringJSON.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            print(str)
            self.label.text = str
        }
    }
    @IBAction func toggle(_ sender: UIButton) {
        sender.isSelected.toggle()
        let db = Firestore.firestore();
        var ref: DocumentReference? = nil

        let save = SavedRecipe(name: recipeName, image: recipeImage, id: recipeID)
        if (sender.isSelected) {
            savedRecipeArray.append(save)
            
            db.collection("userData").document(unique).getDocument { (document, error) in
                if let document = document, document.exists {
                    let doc = db.collection("userData").document(unique)
                    doc.updateData(["savedRecipeID":FieldValue.arrayUnion([recipeID])])
                    doc.updateData(["savedRecipeName":FieldValue.arrayUnion([recipeName])])
                    doc.updateData(["savedRecipeImg":FieldValue.arrayUnion([recipeImage])])
                }
                else {
                    print("Document does not exist")
                    ref = db.collection("userData").addDocument(data: [
                        "id": userToken,
                        "ingredients": [String](),
                        "savedRecipeID": [String](),
                        "savedRecipeName": [String](),
                        "savedRecipeImg": [String]()
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    }
                }
            }
        }
        else {
            savedRecipeArray = savedRecipeArray.filter{$0.name != recipeName}
            print(savedRecipeArray)
            let doc = db.collection("userData").document(unique)
            doc.updateData(["savedRecipeID":FieldValue.arrayRemove([recipeID])])
            doc.updateData(["savedRecipeName":FieldValue.arrayRemove([recipeName])])
            doc.updateData(["savedRecipeImg":FieldValue.arrayRemove([recipeImage])])
        }
    }
}
