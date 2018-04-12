//
//  BreweryService.swift
//  CoreData_Test
//
//  Created by Pavel on 13.03.18.
//  Copyright © 2018 Pavel. All rights reserved.
//

import UIKit
import Alamofire

class BreweryService: NSObject {
    
    private static var sharedManager: BreweryService = {
        let breweryService = BreweryService()
        return breweryService
    }()
    
    class func shared() -> BreweryService {
        return sharedManager
    }
    
    func getBreweryList(completionHandler: @escaping (Bool, Array<Any>) -> Void){
        let url = brewery_Api_Url + "breweries"
        let parameters = ["key" : brewery_Api_Key]
        getRequest(url: url, parameters: parameters) { (success, breweries) in
            completionHandler(success, breweries as! Array)
        }
    }
    
    func getBeerList(breweryId: String, completionHandler: @escaping (Bool, Array<Any>) -> Void){
        let url = brewery_Api_Url + "brewery/" + breweryId + "/beers"
        let parameters = ["key" : brewery_Api_Key]
        getRequest(url: url, parameters: parameters) { (success, beers) in
            completionHandler(success, beers as! Array)
        }
    }
    
    func getBeerList(completionHandler: @escaping (Bool, Array<Any>) -> Void){
        let url = brewery_Api_Url + "beers"
        let parameters = ["key" : brewery_Api_Key]
        getRequest(url: url, parameters: parameters) { (success, beers) in
            completionHandler(success, beers as! Array)
        }
    }
    
    func getRequest(url: String, parameters: Dictionary<String, String>, completionHandler: @escaping (Bool, Any) -> Void){
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let result = response.result.value {
                let JSON = result as! Dictionary<String, Any>
                if ((JSON["status"] as! String) == "success" && (JSON["data"] != nil)){
                    let breweries: Array<Any> = JSON["data"] as! Array
                    completionHandler(true, breweries)
                }
                else{
                    completionHandler(false, [])
                }
            }
            else{
                completionHandler(false, [])
            }
        }
    }
    
}
