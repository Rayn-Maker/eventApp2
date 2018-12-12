//
//  SetUpPortfolioVC.swift
//  eventApp2
//
//  Created by Radiance Okuzor on 12/9/18.
//  Copyright © 2018 RayCo. All rights reserved.
//
// services offered are event planners caterers (business or individuals) venue provider (business)
// inpute certificates, places worked, jobs done.

import UIKit

class SetUpPortfolioVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var workEmail: UITextField!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var servToAddTable: UITableView!
    @IBOutlet weak var selectServTable: UITableView!
    
    
    let textView = UITextView(frame: CGRect(x: 0, y: 50, width: 260, height: 162))
    static var serviceToAddArray = ["Event Planner", "Caterer","Venue Provider","Photographer","publicizer","Clown", "DJ"]
    static var selectedServArr = [String]()
    var bio = "Bio:"
    static var worker = Worker()
    var msg = ""
    let picker = UIImagePickerController()
    let commonFuncs = CommonFunctions()
    var screenPageCount = 1
    static var service = Service()
    static let shared = SetUpPortfolioVC()
    static var servPageTitle = ""
    static var serviceToRemoveIndxPth = 0
    static var reloadServc = false
    static var isShowingServpage = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dismissKeyboard()
        picker.delegate = self
        if screenPageCount == 3 {
            showScrn3()
        }
        if SetUpPortfolioVC.isShowingServpage {
            titleOfServPage.topItem?.title = SetUpPortfolioVC.servPageTitle
            SetUpPortfolioVC.isShowingServpage = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if SetUpPortfolioVC.reloadServc{
            reloadServics()
            SetUpPortfolioVC.reloadServc = false
        }
    }
    
    @IBAction func nextPrsd(_ sender: UIButton) {
        
        if firstName.text != "" && lastName.text != "" && workEmail.text != "" && SetUpPortfolioVC.selectedServArr.count != 0 && bioText.text != "" {
            SetUpPortfolioVC.worker.firstName = firstName.text; SetUpPortfolioVC.worker.lastName = lastName.text; SetUpPortfolioVC.worker.wrkEmail = workEmail.text; SetUpPortfolioVC.worker.bio = bioText.text
            performSegue(withIdentifier: "signUpPage1To2", sender: self)
            self.screenPageCount += 1
        } else {
            if firstName.text == "" {msg = "please fill out first name"}
            if lastName.text == "" {msg = "please fill out last name"}
            if workEmail.text == "" {msg = "please fill out workers email"}
            if bioText.text == "" {msg = "please add a bio"}
            if SetUpPortfolioVC.selectedServArr.count == 0 {msg = "please select a service you offer"}
            
            let alert = UIAlertController(title: "Missing field", message: msg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextPrsd2(_ sender: UIButton) {
        if bussAddrs.text != "" && busnPhone.text != "" {
            SetUpPortfolioVC.worker.bsnAdrs = bussAddrs.text; SetUpPortfolioVC.worker.wrkPhnNmbr = Int(busnPhone.text); SetUpPortfolioVC.worker.wbstLnk = wbLnk.text
            self.screenPageCount += 1
            performSegue(withIdentifier: "signUpPage2To3", sender: self)
        } else {
            if bussAddrs.text == "" {msg = "please fill out first name"}
            if busnPhone.text == "" {msg = "please fill out last name"}
            
            
            let alert = UIAlertController(title: "Missing field", message: msg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func addBio(_ sender: UIButton) {
        let alertView = UIAlertController(title: "Add bio....", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        alertView.view.addSubview(textView)
        
        let post = UIAlertAction(title: "Save", style: .default) { (_) in
            self.bio = self.textView.text!
            self.bioText.text = self.bio
        }
        let cancel = UIAlertAction(title: "cancel", style: .destructive) { (_) in
            self.bio = "Bio:"
            self.bioText.text = self.bio
        }
        alertView.addAction(post); alertView.addAction(cancel)
        present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func backPrsd(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        if screenPageCount >= 2 {
            screenPageCount -= 1
        }
    }
    
    //// Page 2
    @IBOutlet weak var bussAddrs: UITextView!
    @IBOutlet weak var busnPhone: UITextView!
    @IBOutlet weak var wbLnk: UITextView!
    @IBOutlet weak var prflPic: UIImageView!
    
    @IBAction func addPic(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    //// page 3
    @IBOutlet weak var prflPic2: UIImageView!
    @IBOutlet weak var infoTxt: UITextView!
    @IBOutlet weak var bkgrndPic: UIImageView!
    @IBOutlet weak var bioTxt: UITextView!
    @IBOutlet weak var slctdSrvTbl: UITableView!
    
    @IBAction func donePrsd(_ sender: Any) {
        
    }
    
    /// save new service screen

    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var busPicsCollectionView: UICollectionView!
    @IBOutlet weak var titleOfServPage: UINavigationBar!
    
    @IBAction func saveServ(_ sender: Any) {
        SetUpPortfolioVC.service.price = Int(priceTxt.text!)
        SetUpPortfolioVC.reloadServc = true
        SetUpPortfolioVC.selectedServArr.append(SetUpPortfolioVC.service.name)
        SetUpPortfolioVC.serviceToAddArray.remove(at: SetUpPortfolioVC.serviceToRemoveIndxPth)
        SetUpPortfolioVC.selectedServArr = SetUpPortfolioVC.selectedServArr.sorted(by: < )
        SetUpPortfolioVC.worker.srvcs.append(SetUpPortfolioVC.service)
        self.dismiss(animated: true, completion: nil)
//        performSegue(withIdentifier: "serviceRetSeg", sender: self)
    }
    
    @IBAction func experienceLvl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            SetUpPortfolioVC.service.levExp = "Beginner"
        }
        if sender.selectedSegmentIndex == 1 {
            SetUpPortfolioVC.service.levExp = "Skilled"
        }
        if sender.selectedSegmentIndex == 2 {
            SetUpPortfolioVC.service.levExp = "Expert"
        }
        if sender.selectedSegmentIndex == 3 {
            SetUpPortfolioVC.service.levExp = "Sage"
        }
    }
    
    @IBAction func addBusPicsPrsd(_ sender: Any) {
    }
    
    @IBAction func bkToServpgPrsd(_ sender: Any) {
//        performSegue(withIdentifier: "serviceRetSeg", sender: self)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func reloadServics(){
        servToAddTable.reloadData()
        selectServTable.reloadData()
    }
    func showScrn3(){
        bioTxt.text = SetUpPortfolioVC.worker.bio
        infoTxt.text = "Name: \(SetUpPortfolioVC.worker.firstName ?? "" + " " + SetUpPortfolioVC.worker.lastName )\nEmail: \(SetUpPortfolioVC.worker.wrkEmail ?? "") \nAds: \(SetUpPortfolioVC.worker.bsnAdrs ?? "")\nPhn: \(SetUpPortfolioVC.worker.wrkPhnNmbr ?? 0)\nYrsWrk:\(SetUpPortfolioVC.worker.yrsWrkng ?? "")\nWeb: \(SetUpPortfolioVC.worker.wbstLnk ?? "")"
        prflPic2.image = SetUpPortfolioVC.worker.image
        prflPic2 = self.commonFuncs.editImage(image: prflPic2!)
        bkgrndPic.image = SetUpPortfolioVC.worker.image
        slctdSrvTbl.reloadData()
    }
    
    func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == bussAddrs {bussAddrs.text = ""; bussAddrs.textColor = UIColor.black};if textView == busnPhone {busnPhone.text = ""; busnPhone.textColor = UIColor.black};if textView == wbLnk {wbLnk.text = "";wbLnk.textColor = UIColor.black}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // UIImagePickerControllerEditedImage
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.prflPic.image = image
            let data = self.prflPic.image!.jpegData(compressionQuality: 0.5)
            SetUpPortfolioVC.worker.profilePicData = data
            SetUpPortfolioVC.worker.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension SetUpPortfolioVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == servToAddTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "serviceToAddCell", for: indexPath)
            cell.textLabel!.text = SetUpPortfolioVC.serviceToAddArray[indexPath.row]
            
            return cell
        } else if tableView == selectServTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectedServCell", for: indexPath)
            cell.textLabel!.text = SetUpPortfolioVC.selectedServArr[indexPath.row]
            
            return cell
        } else if tableView == slctdSrvTbl {
            let cell = tableView.dequeueReusableCell(withIdentifier: "slctdServCell", for: indexPath)
            cell.textLabel!.text = SetUpPortfolioVC.worker.srvcs[indexPath.row].name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectedServCell", for: indexPath)
            cell.textLabel!.text = SetUpPortfolioVC.selectedServArr[indexPath.row]
            
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == servToAddTable {
            return SetUpPortfolioVC.serviceToAddArray.count
        } else  if tableView == selectServTable {
            return SetUpPortfolioVC.selectedServArr.count
        } else if tableView == slctdSrvTbl {
            return SetUpPortfolioVC.worker.srvcs.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == servToAddTable {
            SetUpPortfolioVC.isShowingServpage = true
            SetUpPortfolioVC.servPageTitle = SetUpPortfolioVC.serviceToAddArray[indexPath.row]
            SetUpPortfolioVC.service.name = SetUpPortfolioVC.serviceToAddArray[indexPath.row]
            SetUpPortfolioVC.serviceToRemoveIndxPth = indexPath.row
            performSegue(withIdentifier: "serviceSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == selectServTable {
            var servc = Service()
            SetUpPortfolioVC.serviceToAddArray.append(SetUpPortfolioVC.selectedServArr[indexPath.row])
            SetUpPortfolioVC.serviceToAddArray = SetUpPortfolioVC.serviceToAddArray.sorted(by: < )
            servc.name = SetUpPortfolioVC.selectedServArr[indexPath.row]
            SetUpPortfolioVC.selectedServArr.remove(at: indexPath.row)
            for x in 0...SetUpPortfolioVC.worker.srvcs.count - 1 {
                if SetUpPortfolioVC.worker.srvcs[x].name == servc.name {
                    SetUpPortfolioVC.worker.srvcs.remove(at: x)
                    continue
                }
            }
            slctdSrvTbl.reloadData()
            servToAddTable.reloadData()
            selectServTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == servToAddTable {
            return "Select a services"
        } else if tableView == selectServTable {
            return "My Services"
        } else {
            return "My Services"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpPage1To2"{
            let vc = segue.destination as? SetUpPortfolioVC
//            vc?.worker = self.worker
            vc?.screenPageCount = screenPageCount
        }
        if segue.identifier == "signUpPage2To3"{
            let vc = segue.destination as? SetUpPortfolioVC
//            vc?.worker = self.worker
            vc?.screenPageCount = 3
        }
        if segue.identifier == "serviceSegue"{
            let vc = segue.destination as? SetUpPortfolioVC
//            vc?.worker = self.worker
//            vc?.service = service
//            vc?.selectedServArr = selectedServArr
//            vc?.serviceToAddArray = serviceToAddArray
//            vc?.reloadServc = false
        }
        if segue.identifier == "serviceRetSeg"{
            let vc = segue.destination as? SetUpPortfolioVC
//            vc?.worker = self.worker
//            vc?.service = service
//            vc?.selectedServArr = selectedServArr
//            vc?.serviceToAddArray = serviceToAddArray
//            vc?.reloadServc = true
        }
    }
}
