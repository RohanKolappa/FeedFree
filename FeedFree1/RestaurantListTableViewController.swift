//
//  RestaurantListTableViewController.swift
//  FeedFree1
//
//  Created by Rohan Kolappa on 6/21/19.
//

import UIKit
import SwiftyJSON

class RestaurantListTableViewController: UITableViewController {

    @IBOutlet weak var registerButton: UIBarButtonItem!
    
    var id = 0
    var name = ""
    var image = ""
    var address = ""
    var status = false
    var email = ""
    var mobile_number = ""
    var comment = ""
    var selectedCity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
     //   self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        //self.navigationController?.popViewController(animated: false)
        //getRestaurantList(city: selectedCity)
       // self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addRestaurant))
    }

    @objc private func addRestaurant() {
        self.present(AddRestaurantViewController(), animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getRestaurantList(city: selectedCity)
        //tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //let indexPath = IndexPath(row: 0, section: 0)
        //self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private var restaurants: [Restaurant] = [] {
        didSet {
            //tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    @objc func getRestaurantList(city: String) {
        selectedCity = city
        //Call API
        RestApiManager.sharedInstance.getRestaurantList(city: city) { (json: JSON) in
            //return json from API
            self.restaurants = []
            if let restaurants_arr = json["organizations"].array {
                for restaurant in restaurants_arr {
                    self.restaurants.append(Restaurant(json: restaurant))
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RestaurantTableViewCell"
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RestaurantTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RestaurantTableViewCell.")
        }
        
        let restaurant = restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.name
        cell.statusSwitch.isOn = restaurant.status
        cell.iconImage.image = UIImage(url: URL(string: restaurant.iconURL))
        //cell.iconImage.image = (UIImage(imageLiteralResourceName: image))
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RestaurantDetailsViewController {
            destination.name = name
            destination.image = UIImage(url: URL(string: image)) ?? UIImage(imageLiteralResourceName: "no-image-icon")
            destination.address = address
            destination.status = status
            destination.comment = comment
            destination.id = id
            destination.city = selectedCity
            //destination.image = (UIImage(imageLiteralResourceName: image))
        }
        
        if let destination = segue.destination as? LoginViewController {
                destination.city = selectedCity
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        id = restaurants[indexPath.row].id
        name = restaurants[indexPath.row].name
        image = restaurants[indexPath.row].iconURL
        address = restaurants[indexPath.row].address
        status = restaurants[indexPath.row].status
        email = restaurants[indexPath.row].email
        mobile_number = restaurants[indexPath.row].mobile_number
        comment = restaurants[indexPath.row].comment
        
        //image = "no-iage-icon"
        performSegue(withIdentifier: "RestaurantDetailsSegue", sender: self)
    }



}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

