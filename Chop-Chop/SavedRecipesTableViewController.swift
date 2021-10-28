//
//  SavedRecipesTableViewController.swift
//  Chop-Chop
//
//  Created by Seulmin Ryu on 5/14/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import GoogleSignIn

var savedRecipeArray = [SavedRecipe]()
class SavedRecipesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRecipeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = savedRecipeArray[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(savedRecipeArray[indexPath.row])
        recipeID = savedRecipeArray[indexPath.row].id
        recipeName = savedRecipeArray[indexPath.row].name
        recipeImage = savedRecipeArray[indexPath.row].image
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let nav = storyboard.instantiateViewController(withIdentifier: "specificRecipe") as! UINavigationController
        let vc = storyboard.instantiateViewController(withIdentifier: "exploreSpecific")
        nav.pushViewController(vc, animated: true)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil);
    }
    
    @IBAction func logout(_ sender: Any) {
        print("Signing Out")
        GIDSignIn.sharedInstance().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "loginView") ; // MySecondSecreen the storyboard ID
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil);
    }
}
