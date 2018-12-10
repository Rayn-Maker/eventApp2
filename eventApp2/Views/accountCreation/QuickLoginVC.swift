//
//  QuickLoginVC.swift
//  eventApp2
//
//  Created by Radiance Okuzor on 12/7/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class QuickLoginVC: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    var doesHaveAcct = false
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref2 = Database.database().reference()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        // Do any additional setup after loading the view.
    }
    
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        // ...
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            ref = Database.database().reference()
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    
                    return
                } else {
                    self.ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.hasChild(Auth.auth().currentUser?.uid ?? ""){
                            
                        } else {
                            let imageUrl = user.profile.imageURL(withDimension: 400).absoluteString
                            let url  = NSURL(string: imageUrl) as! URL
                            let data = NSData(contentsOf: url)
                            
                            user.profile.imageURL(withDimension: 400)
                            self.user.firstName = user.profile.givenName; self.user.lastName = user.profile.familyName; self.user.email = user.profile.email; self.user.fullName = user.profile.name; self.user.profilePicData = data! as Data
                            
                            
                            let userInfo: [String: Any] = ["uid": Auth.auth().currentUser?.uid ?? "",
                                                           "fName": user.profile.givenName ?? " ",
                                                           "lName": user.profile.familyName ?? " ",
                                                           "full_name": user.profile.name ?? " ",
                                                           "email": user.profile.email ?? " ",
                                                           "title":"user"]
                            
                            self.ref.child("Users").child(Auth.auth().currentUser?.uid ?? "").setValue(userInfo, withCompletionBlock: { (err, resp) in
                                if err != nil {
                                    self.doesHaveAcct = true
                                    self.performSegue(withIdentifier: "signInToEdit", sender: self)
                                } else {
                                    
                                }
                            })
                            //                            self.addCustomer(child: Auth.auth().currentUser?.uid ?? "", userEmail: user.profile.email)
                        }
                    })
                }
                if authResult != nil {
                    //already have acount
                    let imageUrl = user.profile.imageURL(withDimension: 400).absoluteString
                    let url  = NSURL(string: imageUrl) as! URL
                    let data = NSData(contentsOf: url)
                    
                    user.profile.imageURL(withDimension: 400)
                    self.user.firstName = user.profile.givenName; self.user.lastName = user.profile.familyName; self.user.email = user.profile.email; self.user.fullName = user.profile.name; self.user.profilePicData = data! as Data
                    self.doesHaveAcct = true
                    self.performSegue(withIdentifier: "signInToEdit", sender: self)
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newAcctSeg" {
            let vc = segue.destination as? CreateAccVC
            vc?.user = self.user
            vc?.doesHaveAcct = self.doesHaveAcct
        } //createAccSeg
        if segue.identifier == "signInToEdit" {
            let vc = segue.destination as? CreateAccVC
            vc?.user = self.user
            vc?.doesHaveAcct = self.doesHaveAcct
        }
    }

}
