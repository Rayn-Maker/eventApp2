//
//  FBLoginVC.swift
//  eventApp2
//
//  Created by Radiance Okuzor on 12/7/18.
//  Copyright © 2018 RayCo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FBLoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passCode: UITextField!
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        dismissKeyboard()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        ref = Database.database().reference()
        guard emailField.text != "", passCode.text != "" else {return}
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passCode.text!, completion: { (user, error) in
            
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "dismiss", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
            
            
            if let user = user {
                //                self.addCustomer(child: Auth.auth().currentUser?.uid ?? "", userEmail: emailField.text)
                
                let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDel.logUser()
            }
        })
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
