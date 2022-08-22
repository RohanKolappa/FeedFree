//
//  LoginViewController.swift
//  FeedFree1
//
//  Created by Rohan Kolappa on 6/23/19.
//

import UIKit
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
//import FacebookCore
//import FacebookLogin


class LoginViewController: UIViewController, GIDSignInUIDelegate {

    var user: String?
    var password: String?
    var status_code: Int?
    var email = ""
    var city = ""
    var source = ""
    
    //var postString = [String]()
    @IBOutlet weak var yserText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBAction func facebookLoginClicked(_ sender: Any) {
       /* let fbLoginManager:LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) {(result, error) in
            if (error == nil) {
                let fbLoginResult:LoginManagerLoginResult = result!
                if fbLoginResult.grantedPermissions != nil {
                    if (fbLoginResult.grantedPermissions.contains("email")) {
                        
                    }
                }
            }
        }*/
        
        let fbLoginManager:LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["email"], from: self, handler: {(result, error) -> Void in
            if error != nil {
                print("Process error")
            }
            else if (result?.isCancelled)! {
                print("Cancelled")
            }
            else {
                print("Logged in")
              /*  DispatchQueue.main.async(execute: {
                    let viewController:UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddRestaurantViewContoller") as! UITabBarController
                    self.present(viewController, animated: true, completion: nil)
                }) */
                self.performSegue(withIdentifier: "AddRestaurantViewSegue", sender: nil)
            }
            
        })
        
    }
    
    func loginButtonDidLogout(_ loginButton: FBLoginButton!) {
        print("User Logout")
    }
    
    func GetFBUserData() {
        if ((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: {(conneection, result, error) -> Void in
                if (error == nil) {
                    let faceDic = result as! [String:AnyObject]
                    print(faceDic)
                    let email = faceDic["email"] as! String
                    print(email)
                    let id = faceDic["id"] as! String
                    print(id)
                }
            })
        }
    }
    
    
    
    @IBAction func onClick(_ sender: Any, forEvent event: UIEvent) {
        user = self.yserText.text
        password = self.passwordText.text
        let postString = ["user": self.yserText.text!,
        "password": self.passwordText.text!] as [String: String]
        validateLogin(postString: postString)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(registerOrganization(_:)), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)
        //showRestaurantList()

        // Do any additional setup after loading the view.
    }
    
    @objc func validateLogin(postString: [String: String]) {
        //Call API
        RestApiManager.sharedInstance.getUser(postString: postString) { (json: JSON) in
            let status_code = json["status_code"]
            if json["status_code"] == 0 {
                print("User Not Found")
            }
            else {
                self.navigationController?.pushViewController(AddRestaurantViewController(), animated: true)
            }
           
            //return json from API
           // if let restaurants_arr = json["organizations"].array {
           //     for restaurant in restaurants_arr {
           //         self.restaurants.append(Restaurant(json: restaurant))
           //     }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddRestaurantViewController {
            destination.email = email
            destination.city = city
            destination.source = source
        }
    }
    
    @objc func registerOrganization(_ notification: NSNotification) {
        if let currentUser = GIDSignIn.sharedInstance()?.currentUser {
            print(notification.userInfo ?? "")
            if let dict = notification.userInfo as NSDictionary? {
                email = dict["email"] as? String ?? ""
                print(email)
                source = dict["source"] as? String ?? ""
            } //navigationController?.pushViewController(AddRestaurantViewSegue(), animated: true)
            self.performSegue(withIdentifier: "AddRestaurantViewSegue", sender: nil)
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
