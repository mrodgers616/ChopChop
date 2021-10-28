//
//  StartViewController.swift
//  Chop-Chop
//
//  Created by Seulmin Andy Ryu on 5/3/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseUI
import FirebaseFirestore
import SwiftyJSON
import Alamofire

var unique = "abc"
class StartViewController: UIViewController {
    @IBOutlet weak var ingredients: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Once you go back to start, clear all the previous scans
//        var scans = Scans.allScans
//        scans.removeAll()
//        print(scans)
        print("yeeet")
        Input.allInputs.removeAll()
        savedRecipeArray.removeAll()
        
        let db = Firestore.firestore();
        db.collection("userData").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    //print(document.data())
                    let json = JSON(document.data())
                    //print(json["id"])
                    if (json["id"].stringValue == userToken) {
                        unique = document.documentID
                        let len = json["ingredients"].count
                        
                        if (len != 0) {
                            for i in 0...(len-1) {
                                Input.allInputs.append(json["ingredients"][i].stringValue)
                            }
                        }
                        
                        for i in json["savedRecipeName"].indices {
                            let element = SavedRecipe(name: json["savedRecipeName"][i].1.stringValue, image: json["savedRecipeImg"][i].1.stringValue, id: json["savedRecipeID"][i].1.stringValue)
                            
                            savedRecipeArray.append(element)
                        }
                    }
                }
            }
        }
    }

    @IBAction func logout(_ sender: Any) {
        print("Signing Out")
        GIDSignIn.sharedInstance().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "loginView") ; // MySecondSecreen the storyboard ID
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil);
    }
    @IBAction func generate(_ sender: Any) {
        let allIngredients = ingredients.text!
        let ingredientsArray = allIngredients.components(separatedBy: ",")
        var temp = [String]()
        for string in ingredientsArray {
            Input.allInputs.append(string.trimmingCharacters(in: .whitespacesAndNewlines))
            temp.append(string.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        let db = Firestore.firestore();
        var ref: DocumentReference? = nil
        
        let trimmed = ingredientsArray.map { $0.trimmingCharacters(in: .whitespaces) }
        
        
        db.collection("userData").document(unique).getDocument { (document, error) in
            if let document = document, document.exists {
                let doc = db.collection("userData").document(unique)
                doc.updateData(["ingredients":FieldValue.arrayUnion(trimmed)])
            }
            else {
                print("Document does not exist")
                ref = db.collection("userData").addDocument(data: [
                    "id": userToken,
                    "ingredients": temp,
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
}
