//
//  EditProfileVC.swift
//  eventApp2
//
//  Created by Radiance Okuzor on 12/7/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import GoogleSignIn

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var phoneNmbrTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var passCode: UITextField!
    @IBOutlet weak var passCodeCnf: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    var customerInfo = [String]()
    var imageDidChange = false
    var doesHaveAcct = true
    var userInfo = [String]()
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ///display user info
        if !customerInfo.isEmpty {
            firstNameTxt.text = customerInfo[0]
            lastNameTxt.text = customerInfo[1]
            emailTxt.text = customerInfo[2]
        }
        if let pictureDat = UserDefaults.standard.object(forKey: "pictureData") as? Data {
            profilePic.image = UIImage(data: pictureDat)
        }
        
        if let userInf = UserDefaults.standard.object(forKey: "userInfo") as? [String] {
            userInfo = userInf
            firstNameTxt.text = userInf[0]; lastNameTxt.text = userInf[1]; emailTxt.text = userInf[2]; phoneNmbrTxt.text = userInf[3]
        }
        
        let storage = Storage.storage().reference(forURL: "gs://eventapp2-225e3.appspot.com")
        userStorage = storage.child("Users")
        ref = Database.database().reference()
        ///
        
        picker.delegate = self
        dismissKeyboard()
        editImage()
    }
    
 
    @IBAction func changePicPrsd(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        imageDidChange = true
    }
    
    @IBAction func addCard(_ sender: Any) {
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        logout()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signIn") as! QuickLoginVC
        self.window?.rootViewController = vc
    }
    
    @IBAction func save(_ sender: Any) {
        if doesHaveAcct {
            saveUserInfo()
        } else {
            creatNewAcct()
        }
    }
    
    var storageRef: Storage {
        return Storage.storage()
    }
    
    func logout() {
        if Auth.auth().currentUser != nil {
            do {
                try? Auth.auth().signOut()
            } catch  {
            }
        }
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // UIImagePickerControllerEditedImage
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profilePic.image = image
            let data = self.profilePic.image!.jpegData(compressionQuality: 0.5)
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveImage() {
        
        let user = Auth.auth().currentUser
        let imageRef = self.userStorage.child("\(user?.uid ?? "").jpg")
        let data = self.profilePic.image!.jpegData(compressionQuality: 0.5)
        UserDefaults.standard.set(data, forKey: "pictureData")
        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
            if err != nil {
                print(err!.localizedDescription)
                let alert = UIAlertController(title: "Oopps", message: err?.localizedDescription, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            } else {
            }
            
            imageRef.downloadURL(completion: { (url, er) in
                if er != nil {
                    print(er!.localizedDescription)
                }
                if let url = url {
                    //                    self.student.pictureUrl = url.absoluteString
                    self.ref.child("Users").child(user!.uid).child("pictureUrl").setValue(url.absoluteString)
                    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDel.logUser()
                    
                }
            })
        })
        uploadTask.resume()
    }
    
    func editImage(){
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
    func saveUserInfo(){
        if phoneNmbrTxt.text != nil && phoneNmbrTxt.text != "" && emailTxt.text != nil && emailTxt.text != "" && firstNameTxt.text != "" && firstNameTxt.text != nil && lastNameTxt.text != nil && lastNameTxt.text != "" && profilePic.image != nil {
            
            let userInfo: [String: Any] = [
                "fName": firstNameTxt.text ?? " ",
                "lName": lastNameTxt.text ?? " ",
                "full_name": "\(firstNameTxt.text!) \(lastNameTxt.text ?? " ")",
                "email": emailTxt.text ?? " ",
                "phoneNumber": Int(phoneNmbrTxt.text!)!,
                "title":"user"]
            let userAr = [firstNameTxt.text,lastNameTxt.text,emailTxt.text,phoneNmbrTxt.text ]
            UserDefaults.standard.set(userAr, forKey: "userInfo")
            
            self.ref.child("Users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(userInfo, withCompletionBlock: { (err, resp) in
                if err != nil {
                    
                } else {
                    
                }
            })
            if imageDidChange {
                self.saveImage()
            } else {
                let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDel.logUser()
            }
        }
    }
    
    func creatNewAcct() {
        if passCode.text != passCodeCnf.text && phoneNmbrTxt.text != nil && phoneNmbrTxt.text != "" && emailTxt.text != nil && emailTxt.text != "" && firstNameTxt.text != "" && firstNameTxt.text != nil && lastNameTxt.text != nil && lastNameTxt.text != "" && profilePic.image != nil {
            let alert = UIAlertController(title: "Error", message: "please make sure your passwords match", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: self.emailTxt.text!, password: self.passCode.text! ) { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let userInfo: [String: Any] = [
                        "uid": user!.user.uid,
                        "fName": self.firstNameTxt.text ?? " ",
                        "lName": self.lastNameTxt.text ?? " ",
                        "full_name": "\(self.firstNameTxt.text!) \(self.lastNameTxt.text ?? " ")",
                        "email": self.emailTxt.text ?? " ",
                        "phoneNumber": self.phoneNmbrTxt.text!,
                        "title":"user"]
                    
                    let userAr = [self.firstNameTxt.text,self.lastNameTxt.text,self.emailTxt.text,self.phoneNmbrTxt.text ]
                    UserDefaults.standard.set(userAr, forKey: "userInfo")
                    self.ref.child("Users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(userInfo, withCompletionBlock: { (err, resp) in
                        if err != nil {
                            
                        } else {
                            
                        }
                    })
                    if self.imageDidChange {
                        self.saveImage()
                    } else {
                        let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDel.logUser()
                    }
                }
            }
        }
    }
}
