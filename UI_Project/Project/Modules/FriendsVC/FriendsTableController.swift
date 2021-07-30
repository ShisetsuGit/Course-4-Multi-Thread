//
//  FriendsTableController.swift
//  UI_Project
//
//  Created by Shisetsu on 11.12.2020.
//

import UIKit
import RealmSwift
import Kingfisher
import FirebaseAuth

class FriendsTableController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchBarStatus = false
    
    let friendsRequest = APIRequest()
    let DB = UsersDatabaseService()
    
    var token: NotificationToken?
    
    var filteredData = [UserModel]()
    
    var friendsData: Results<UserModel>?{
        didSet {
            token = friendsData!.observe { [weak self] (changes: RealmCollectionChange) in
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
        self.tableView.rowHeight = 60
        friendsRequest.getFriends()
        friendsData = DB.readResults()
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = friendsData!.filter ({ (friend: UserModel) -> Bool in
            return friend.firstName!.lowercased().contains(searchText.lowercased())
        })
        searchBar.showsCancelButton = true
        searchBarStatus = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        searchBarStatus = false
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 30, y: 20, width: 42, height: 42))
        returnedView.backgroundColor = UIColor.lightGray
        returnedView.alpha = 0.5
        
        let label = UILabel(frame: CGRect(x: 4, y: 4, width: 160, height: 20))
        label.textColor = .black
        if searchBarStatus {
            label.text = "Результат поиска"
        } else {
            label.text = "Список друзей"
        }
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchBarStatus {
            return filteredData.count
        }
        let count = friendsData!.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(
            withDuration: 0.25,
            animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let viewAvatar = tableView.cellForRow(at: indexPath) as? TableViewCell else {return}
        
        let spring = CASpringAnimation(keyPath: "transform.scale")
        spring.duration = 0.5
        spring.damping = 0.1
        spring.initialVelocity = 0.1
        spring.fromValue = 1
        spring.toValue = 0.9
        
        let animation = CAAnimationGroup()
        animation.duration = 1
        animation.animations = [spring]
        
        viewAvatar.headerView.layer.add(animation, forKey: "spring")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userFriends", for: indexPath) as! TableViewCell
        
        
        if searchBarStatus {
            let friends = filteredData[indexPath.row]
            cell.friendLabel.text = friends.firstName! + " " + friends.lastName!
            
            imageCache(url: friends.photo50!) { image in
                cell.friendPhoto.image = image
            }
        } else {
            let friends = friendsData![indexPath.row]
            cell.friendLabel.text = friends.firstName! + " " + friends.lastName!
            
            imageCache(url: friends.photo50!) { image in
                cell.friendPhoto.image = image
            }
        }
        
        cell.friendPhoto.clipsToBounds = true
        cell.friendPhoto.layer.cornerRadius = cell.friendPhoto.frame.height / 2
        cell.headerView.addSubview(cell.friendPhoto)
        
        cell.addSubview(cell.headerView)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProfileController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            if searchBarStatus {
                let friends = filteredData[indexPath.row]
                vc.userID = friends.id
                vc.userPhoto = friends.photo100!
                vc.userName = friends.firstName
                vc.userSurname = friends.lastName
                vc.userCity = friends.city
                vc.userBirth = friends.bdate
                if friends.online == 1 {
                    vc.userStatus = "Online"
                } else if friends.online == 0 {
                    vc.userStatus = "Offline"
                }
            } else {
                let friends = friendsData![indexPath.row]
                vc.userID = friends.id
                vc.userPhoto = friends.photo100!
                vc.userName = friends.firstName
                vc.userSurname = friends.lastName
                vc.userCity = friends.city
                vc.userBirth = friends.bdate
                if friends.online == 1 {
                    vc.userStatus = "Online"
                } else if friends.online == 0 {
                    vc.userStatus = "Offline"
                }
            }
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginScreen") as! LoginController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
}
