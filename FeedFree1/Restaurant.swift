//
//  Restaurant.swift
//  FeedFree1
//
//  Created by Rohan Kolappa on 6/20/19.
//

import SwiftyJSON

class Restaurant {
    
    //MARK: Properties
    
    var id: Int
    var name: String!
    var iconURL: String!
    var status: Bool
    var email: String!
    var mobile_number: String!
    var land_number: String!
    var address: String!
    var address_more: String!
    var city: String!
    var state: String!
    var zip_code: String!
    var comment: String!
    
    //MARK: Initialization
    required init(json: JSON) {
        id = json["id"].intValue
        iconURL = json["image_url"].stringValue
        name = json["name"].stringValue
        status = json["food_status"].int == 1 ? true : false
        email = json["email_address"].stringValue
        mobile_number = json["mobile_number"].stringValue
        land_number = json["land_number"].stringValue
        address = json["address"].stringValue
        address_more = json["address_more"].stringValue
        city = json["city"].stringValue
        state = json["state"].stringValue
        zip_code = json["zip_code"].stringValue
        comment = json["comment"].stringValue
    }
    
}


