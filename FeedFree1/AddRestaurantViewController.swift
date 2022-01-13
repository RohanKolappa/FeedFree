//
//  AddRestaurantViewController.swift
//  FeedFree1
//
//  Created by Dinesh Kumar on 6/23/19.
//  Copyright © 2019 ThinkSoft Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddRestaurantViewController: UIViewController {
    var email = ""
    var city = ""
    var source = ""
    
    @IBOutlet weak var orgNameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var addressMoreText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var zipText: UITextField!
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var landLineText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    var restaurant = [Restaurant]()
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonClicked(_ sender: Any) {
        let postString = ["name": self.orgNameText.text!,
                          "address": self.addressText.text!,
                          "address_more": self.addressMoreText.text!,
                          "city": self.cityText.text!,
                          "state": self.stateText.text!,
                          "zip_code": self.zipText.text!,
                          "land_number": self.landLineText.text!,
                          "mobile_number": self.mobileText.text!,
                          "email_address": self.emailText.text!,
                          "source": source] as [String: String]
        saveOrganization(postString: postString)
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    func saveOrganization(postString: [String: String]) {
        //Call API
        RestApiManager.sharedInstance.registerOrganization(postString: postString) { (json: JSON) in
            
            print(json)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.text = email
        cityText.text = city
        // Do any additional setup after loading the view.
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
