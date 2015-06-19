//
//  DatabaseInterface.swift
//  E_Connect
//
//  Created by Zeiger, Carl John on 6/18/15.
//  Copyright © 2015 Merck. All rights reserved.
//

import Foundation
import Alamofire

class DatabaseInterface{
    let host_name = "http://econnect-backend.herokuapp.com/"
    
    func registerNewUser(name: String, callback: (Int) -> ()){
        //replace spaces wiht +
        Alamofire.request(.POST, URLString: host_name+"users/", parameters: ["username":name])
            .responseString(){ (request, response, data, error) in
                print(request)
                print(response)
                print(data)
                print(error)
                if(response?.statusCode != 200 || data == nil){
                    callback(-1)
                } else {
                    callback(Int(data!)!)
                }
        }
    }
    
    func getUserCount(userID: Int, callback: (Int) -> ()){
        //validate string
        Alamofire.request(.POST, URLString: host_name+"users/"+String(userID))
            .responseString(){ (request, response, data, error) in
                print(request)
                print(response)
                print(data)
                print(error)
                if(response?.statusCode != 200 || data == nil){
                    callback(-1)
                } else {
                    callback(Int(data!)!)
                }
        }
       
    }
    
    func getLeaderBoard(callback: Array<(Int, String, Int)> -> ()){
        Alamofire.request(.GET, URLString: host_name+"users/")
            .responseJSON { (request,response,data,error) in
                if(response?.statusCode != 200 || data == nil){
                    //callback(nil)
                } else {
                    let format_data = (data as! NSArray) as Array
                    var nested_array: Array<(Int, String, Int)> = [(Int, String, Int)]()
                    
                    for item in format_data {
                        let temp = (item as! NSArray) as Array
                        nested_array.append((temp[0] as! Int, temp [1] as! String, temp[2] as! Int))
                    }
                    callback(nested_array)
                }
        }
    }
    
    func newTransaction(self_id: Int, other_id: Int, callback: (Bool) -> ()){
        Alamofire.request(.POST, URLString: host_name+"transaction/", parameters: ["user_id_1": self_id,"user_id_2":other_id])
            .responseString(){ (request, response, data, error) in
                print(data)
                if(response?.statusCode != 200 || data == nil || data != "Transaction Successful"){
                    callback(false)
                } else {
                    callback(true)
                }
        }    }
    
}