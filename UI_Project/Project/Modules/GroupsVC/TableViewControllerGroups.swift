//
//  TableViewController_Groups.swift
//  UI_Project
//
//  Created by  Shisetsu on 11.12.2020.
//

import UIKit
import RealmSwift
import FirebaseAuth
import FirebaseFirestore

class TableViewControllerGroups: UITableViewController {
    
    let groupsRequest = APIRequest()
    var userReccomendGroups = [GroupsModel]()
    var imageName = UIImage()
    let DB = GroupsDatabaseService()
    var token: NotificationToken?
    let fireDB = Firestore.firestore()
    
    var userGroups: Results<GroupsModel>?{
        didSet {
            token = userGroups!.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    print("INITIAL")
//                    print(changes)
                case .update:
                    tableView.reloadData()
                case .error(let error):
                    print("ERROR")
                    fatalError("\(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsRequest.getGroups()
        userGroups = DB.readResults()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userGroups!.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userGroups", for: indexPath) as! TableViewCellGroups
        
        let groups = userGroups![indexPath.row]
        cell.userGroupsLabel.text = groups.name
        
        imageCache(url: groups.photo50!) { image in
            cell.userGroupsPhoto.image = image
        }
        cell.userGroupsPhoto.layer.cornerRadius = cell.userGroupsPhoto.frame.width / 2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = userGroups![indexPath.row]
            print("GROUP TO DELETE")
            print(item)
            DB.delete(groups: item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    @IBAction func showSerachScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SearchScreen") as! TableViewControllerRecomendGroups
        self.navigationController!.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        var currentUser = Auth.auth().currentUser?.email
        if currentUser == nil {
            currentUser = "no email"
        }
        var userID = Auth.auth().currentUser?.uid
        if userID == nil {
            userID = "no ID"
        }
        if segue.identifier == "addGroup" {
            guard let RecomendedGroups = segue.source as? TableViewControllerRecomendGroups else { return }
            
            if let indexPath = RecomendedGroups.tableView.indexPathForSelectedRow {
                let searchedGroups = RecomendedGroups.sendData[indexPath.row]
                if !userGroups!.contains(searchedGroups) {
                    DispatchQueue.main.async() {
                        do {
                            self.fireDB.collection("Database").document(currentUser!).setData([                            "groupName": FieldValue.arrayUnion([searchedGroups.name!]),
                                "groupPhoto": FieldValue.arrayUnion([searchedGroups.photo50!]),
                                "userID": userID!
                            ],merge: true) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                }
                            }
                            self.DB.add(groups: [searchedGroups])
                        }
                    }
                }
            }
        }
    }
}
