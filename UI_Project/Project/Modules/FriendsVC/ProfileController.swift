//
//  ProfileController.swift
//  UI_Project
//
//  Created by Shisetsu on 21.12.2020.
//

import UIKit
import RealmSwift

class ProfileController: UIViewController {
    
    let photoRequest = APIRequest()
    
    var userPhoto = String()
    var photoArray: Results<PhotoModel>?
    var userName: String!
    var userSurname: String!
    var userCity: String!
    var userBirth: String!
    var userAge: String!
    var userStatus: String!
    var userBio: String!
    var userID: String!
    let DB = PhotoDatabaseService()
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var surname: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var bio: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        photoRequest.getPhoto(userID: userID)
        photoArray = DB.readResults(userID: userID)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(tapGestureRecognizer)
        
        imageCache(url: userPhoto) { image in
            self.avatar.image = image
        }
                
        name.text = userName
        surname.text = userSurname
        if userCity == nil {
            city.text = "Не указан"
        } else {
            city.text = userCity
        }
        if userBirth == nil {
            birthDate.text = "Не указана"
            age.text = "Не указан"
        } else {
            let dateFormat = "dd-MM-yyyy"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            let birth = dateFormatter.date(from: userBirth)
            let currentDate = Date()
            
            if let dateOfBirth = dateFormatter.date(from: userBirth) {
                let calendar = Calendar(identifier: .gregorian)
                let components = calendar.dateComponents([.year], from: dateOfBirth, to: currentDate)
                let yearString = "\(components)"
                age.text = yearString[6..<8]
            }
            
            if birth != nil {
                birthDate.text = userBirth
            } else {
                birthDate.text = "Не указана"
                age.text = "Не указан"
            }
        }
        status.text = userStatus
        if status.text == "Offline" {
            status.textColor = UIColor.red
        } else {
            status.textColor = UIColor.green
        }
        bio.text = userBio
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoGallery") as! CollectionViewController
        vc.photoToFullScreen = photoArray
        vc.userID = userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
