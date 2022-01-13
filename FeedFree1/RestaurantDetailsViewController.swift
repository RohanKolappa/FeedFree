//
//  RestaurantDetailsViewController.swift
//  FeedFree1
//
//  Created by Dinesh Kumar on 6/21/19.
//  Copyright © 2019 ThinkSoft Systems. All rights reserved.
//

import UIKit
import GoogleSignIn
import SwiftyJSON

class RestaurantDetailsViewController: UIViewController, GIDSignInUIDelegate {
    
    var id = 0
    var name = ""
    var image = UIImage()
    var address = ""
    var status = false
    var comment = ""
    var email = ""
    var city = ""
    
    @IBOutlet weak var detailsNavigationItem: UINavigationItem!
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var nameDetailsLabel: UILabel!
    
    @IBAction func closeClicked(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func onSave(_ sender: Any) {
        let postString = ["id": String(id),
                          "name": self.nameText.text!,
                          "address": self.addressText.text!,
                          "food_status": String(self.statusSwitch.isOn),
                          "comment": self.commentText.text!] as [String: String]
        saveOrganization(postString: postString)
        //self.navigationController?.pushViewController(RestaurantListTableViewController(), animated: true)
        //performSegue(withIdentifier: "DetailsToListSegue", sender: self)
    }
    
    func saveOrganization(postString: [String: String]) {
        //Call API
        RestApiManager.sharedInstance.modifyOrganization(postString: postString) { (json: JSON) in
        
            print(json)
        }
        
    }
    
    @IBAction func onClick(_ sender: Any, forEvent event: UIEvent) {
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBAction func signOutButtonClicked(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        editRestaurantDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameText.text = name
        self.addressText.text = address
        self.statusSwitch.isOn = status
        self.imagePhoto.image = image
        self.commentText.text = comment
        //self.detailsNavigationItem.hidesBackButton = false
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userDetails(_:)), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)
        
        editRestaurantDetails()
    }
    
    @objc func userDetails(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            email = dict["email"] as? String ?? ""
            print(email)
        }
        editRestaurantDetails()
    }

    @objc func editRestaurantDetails() {
        if (GIDSignIn.sharedInstance()?.currentUser) != nil {
            signInButton.isHidden = true
            signOutButton.isHidden = false
            nameText.isEnabled = true
            addressText.isEnabled = true
            statusSwitch.isEnabled = true
            commentText.isEnabled = true
            commentText.isHidden = false
        }
            
            
            
        else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            nameText.isEnabled = false
            addressText.isEnabled = false
            statusSwitch.isEnabled = false
            commentText.isEnabled = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
