//
//  ProfileVC.swift
//  eventApp2
//
//  Created by Radiance Okuzor on 12/7/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ProfileVC: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var bgProfilePic: UIImageView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!

    var userStorage: StorageReference!
    var ref: DatabaseReference!
    var userInfo = [String]()
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userInf = UserDefaults.standard.object(forKey: "userInfo") as? [String] {
            userInfo = userInf
            navBar.title = userInf[0] + " " + userInf[1]
        }
        ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://eventapp2-225e3.appspot.com")
        userStorage = storage.child("User")
        fetchUSer()
        editImage()
        if let pictureDat = UserDefaults.standard.object(forKey: "pictureData") as? Data {
            profilePic.image = UIImage(data: pictureDat)
            bgProfilePic.image = UIImage(data: pictureDat)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        if let pictureDat = UserDefaults.standard.object(forKey: "pictureData") as? Data {
        //            profilePic.image = UIImage(data: pictureDat)
        //        }
        fetchUSer()
    }
    
    var storageRef: Storage {
        return Storage.storage()
    }
    
    func editImage(){
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
    func fetchUSer() {
          ref.child("Users").child((Auth.auth().currentUser?.uid)!).queryOrderedByKey().observeSingleEvent(of: .value, with: { response in
            if response.value is NSNull {
                /// dont do anything
            } else {
                let resp = response.value as! [String:AnyObject]
                self.user.firstName = resp["fName"] as? String
                self.user.lastName = resp["lName"] as? String
                self.user.fullName = resp["full_name"] as? String
                self.user.email = resp["email"] as? String
                self.user.phoneNumber = resp["phoneNumber"] as? Int
                if let upc =  resp["pictureUrl"] as? String {
                    self.user.profilePic = upc
                    self.downloadImage(url: self.user.profilePic)
                    UserDefaults.standard.set(upc, forKey: "profilePicURL")
                    UserDefaults.standard.set(self.user.fullName, forKey: "fullName")
                }
                
                
                
                self.navBar.title = self.user.firstName
            }
        })
    }
    
    func downloadImage(url:String) -> Data {
        var datas = Data()
        self.storageRef.reference(forURL: url).getData(maxSize: 1 * 1024 * 1024, completion: { (imgData, error) in
            if error == nil {
                if let data = imgData{
                    self.profilePic.image = UIImage(data: data)
                    self.bgProfilePic.image = UIImage(data: data)
                    self.activitySpinner.stopAnimating()
                }
            }
            else {
                print(error?.localizedDescription)
                self.activitySpinner.stopAnimating()
            }
        })
        
        return datas
    }

}
