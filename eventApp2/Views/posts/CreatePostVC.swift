//
//  CreatePostVC.swift
//  eventApp2
//
//  Created by Radiance Okuzor on 12/7/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CreatePostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    let textView = UITextView(frame:
        CGRect(x: 0, y: 50, width: 260, height: 162))
    
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    var fullName: String?
    var profilePicURL: String?
    var caption: String?
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        picker.delegate = self
        editImage()
        if let pictureUrl = UserDefaults.standard.object(forKey: "profilePicURL") as? String {
            self.profilePicURL = pictureUrl
        } else {
            self.profilePicURL = "missing picture url"
        }
        
        if let fullName = UserDefaults.standard.object(forKey: "fullName") as? String {
            self.fullName = fullName
        } else {
            self.fullName = "Missing Full name "
        }
        
        let storage = Storage.storage().reference(forURL: "gs://eventapp2-225e3.appspot.com")
        userStorage = storage.child("Posts")
        ref = Database.database().reference()
    }
    
    @IBAction func addPic(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadPost(_ sender: Any) {
        let alertView = UIAlertController(
            title: "add comment....",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert)
        
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        textView.text = "Write your comment here..."
        alertView.view.addSubview(textView)
        
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            self.caption = self.textView.text
            self.saveImage()
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "cancel", style: .destructive) { (_) in
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        alertView.addAction(post); alertView.addAction(cancel)
        present(alertView, animated: true, completion: nil)
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    
    func saveImage() {
        let newPost = Post(image: self.profilePic.image!, caption: self.caption ??
            "", authorEmail: Auth.auth().currentUser!.email!, authorFullName: self.fullName!, authorPicUrl: self.profilePicURL!)
        newPost.save()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // UIImagePickerControllerEditedImage
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profilePic.image = image
            let data = self.profilePic.image!.jpegData(compressionQuality: 0.5)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func editImage(){
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
}
