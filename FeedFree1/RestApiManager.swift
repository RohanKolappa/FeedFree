//
//  RestApiManager.swift
//  FeedFree1
//
//  Created by Dinesh Kumar on 6/20/19.
//  Copyright © 2019 ThinkSoft Systems. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias ServiceResponse = (JSON, Error?) -> Void

class RestApiManager: NSObject {
    
    static let sharedInstance = RestApiManager()
    //let baseURL = "http://0.0.0.0:5056/feedfree/"
    let baseURL = "https://feedfreelab-env.bcq2cfqwbx.us-west-1.elasticbeanstalk.com/"
    
    func getUser(postString: [String: String], onCompletion: @escaping (JSON) -> Void) {
        let path = "user"
        var route = baseURL + path
        route = route.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        makeHTTPPostRequest(path: route, body: postString as [String : AnyObject]) { (json: JSON, error: Error?) in
            onCompletion(json as JSON)
        }
    }
    
    func getRestaurantList(city: String, onCompletion: @escaping (JSON) -> Void) {
        let path = "organizations/"
        var route = baseURL + path + city
        //route = route.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        route = route.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        makeHTTPGetRequest(path: route) { (json: JSON, error: Error?) in
            onCompletion(json as JSON)
        }
    }
    
    func modifyOrganization(postString: [String: String], onCompletion: @escaping (JSON) -> Void) {
        let path = "organizations/edit"
        var route = baseURL + path
        route = route.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        makeHTTPPostRequest(path: route, body: postString as [String : AnyObject]) { (json: JSON, error: Error?) in
            onCompletion(json as JSON)
        }
    }
    
    func registerOrganization(postString: [String: String], onCompletion: @escaping (JSON) -> Void) {
        let path = "organizations/register"
        var route = baseURL + path
        route = route.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        makeHTTPPostRequest(path: route, body: postString as [String : AnyObject]) { (json: JSON, error: Error?) in
            onCompletion(json as JSON)
        }
    }
    
    private func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        let request = URLRequest(url: NSURL(string: path)! as URL)
        URLSession.shared.dataTask(with: request) { (data:Data?, response: URLResponse?,
            error:Error?) in
            if let jsonData = data {
                do {
                    let json: JSON = try JSON(data: jsonData)
                    onCompletion(json,nil)
                }catch {
                    onCompletion(JSON(),error)
                }
            } else {
                onCompletion(JSON(),error)
            }
        }.resume()
       
    }

    private func makeHTTPPostRequest(path: String, body:[String:AnyObject], onCompletion:
        @escaping ServiceResponse) {
        var request = URLRequest(url: NSURL(string: path)! as URL)
        request.httpMethod = "POST"
        
        do {
            let jsonBody = try JSONSerialization.data(withJSONObject: body, options:
                JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = jsonBody
            URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?,error:Error?) in
                if let jsonData = data {
                    do {
                        let json:JSON = try JSON(data:jsonData)
    
                        onCompletion(json, nil)
                    }catch{
                        onCompletion(JSON(), error)
                    }
                }else {
                    onCompletion(JSON(), error)
                }
                }.resume()
        }catch {
            onCompletion(JSON(), nil)
        }
        
    }
    
}
