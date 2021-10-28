//
//  ListViewController.swift
//  Chop-Chop
//
//  Created by Seulmin Andy Ryu on 5/13/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseUI
import FirebaseFirestore
import SwiftyJSON

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Input.allInputs)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Input.allInputs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Input.allInputs[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let db = Firestore.firestore();
            var element = Input.allInputs[indexPath.row]
            Input.allInputs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)

            let doc = db.collection("userData").document(unique)
            doc.updateData(["ingredients":FieldValue.arrayRemove([element])])
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
    @IBAction func allRecipes(_ sender: Any) {
        
    }
}
