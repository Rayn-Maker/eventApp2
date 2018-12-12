//
//  PostProfilesVC.swift
//  eventApp2
//
//  Created by Radiance Okuzor on 12/8/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import Firebase

class PostProfilesVC: UIViewController {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var bgProfilePic: UIImageView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet var menuBtns: [UIButton]!
    
    
    var post = Post()
    let ref = Database.database().reference()
    let commonFuncs = CommonFunctions()
    var authProfPic = Data()
    var phoneNumber: Int!
    var email: String!
    var postArr = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilePic.image = UIImage(data: authProfPic)
        bgProfilePic.image = UIImage(data: authProfPic)
        profilePic = commonFuncs.editImage(image: profilePic)
        self.navBar.title = post.authorFullName
        fetchUSer()
        fetchPosts()
    }
    
    @IBAction func menuPrsd(_ sender: UIButton) {
        menuBtns.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    enum menuButons: String {
        case text = "Text"
        case call = "Call"
        case email = "Email"
        case book = "Book"
    }
    
    @IBAction func menuItemTaped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let butt = menuButons(rawValue: title) else {
            return
        }
        switch butt {
        case .call:
            print("make a call")
        case .text:
            print("make a text")
        case .email:
            print("make a email")
        case .book:
            print("make a book")
        default:
            print("dont do notn")
        }
    }
    
    func fetchUSer() {
        ref.child("Users").child(post.authId).queryOrderedByKey().observeSingleEvent(of: .value, with: { response in
            if response.value is NSNull {
                /// dont do anything
            } else {
                let user = User(snapShot: response)
                self.navBar.title = user.fullName
                self.phoneNumber = user.phoneNumber
                self.email = user.email
            }
        })
    }
    
    func fetchPosts() {
        Database.database().reference().child("Users").child(post.authId).child("MyPosts").observe(.childAdded) { (snapshot) in
            let newPost = Post(snapShot: snapshot)
            DispatchQueue.main.async {
                self.postArr.insert(newPost, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.collectionView.insertItems(at: [indexPath])
                self.activitySpinner.stopAnimating()
            }
        }
    }

}

extension PostProfilesVC: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //collectionVIewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionPostsCell", for: indexPath) as! CollectionViewCell
        let post = self.postArr[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
