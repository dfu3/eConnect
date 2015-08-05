//
//  DatabaseInterface.swift
//  E_Connect
//
//  Created by Zeiger, Carl John on 6/18/15.
//  Copyright © 2015 Merck. All rights reserved.
//

import Foundation
import Alamofire

class DatabaseInterface
{
    let host_name = "http://econnect-backend.herokuapp.com/"
    //let host_name = "http://127.0.0.1:5000/"
    
    func registerNewUser(name: String, callback: (Int,Bool) -> ()){
        //replace spaces wiht +
        Alamofire.request(.POST, host_name+"users/", parameters: ["username":name])
            .responseString(){ (request, response, data, error) in
                if(response?.statusCode != 200 || data == nil){
                    callback(-1, false)
                } else {
                    callback(Int(data!)!,true)
                }
        }
    }
    
    func getUserCount(userID: Int, callback: (Int) -> ()){
        Alamofire.request(.GET, host_name+"users/"+String(userID))
            .responseString(){ (request, response, data, error) in
                if(response?.statusCode != 200 || data == nil){
                    callback(-1)
                } else {
                    if let s = data{
                        if let i = Int(s){
                            callback(i)
                        } else {
                            callback(-1)
                        }
                    } else{
                        callback(-1)
                    }
                    
                }
        }
       
    }
    
    func getLeaderBoard(callback: (Bool, Array<(Int, String, Int)>) -> ()){
        Alamofire.request(.GET, host_name+"users/")
            .responseJSON { (request,response,data,error) in
                if(response?.statusCode != 200 || data == nil){
                    callback(false,[(Int, String,Int)]())
                } else {
                    let format_data = (data as! NSArray) as Array
                    var nested_array: Array<(Int, String, Int)> = [(Int, String, Int)]()
                    
                    for item in format_data {
                        let temp = (item as! NSArray) as Array
                        nested_array.append((temp[0] as! Int, temp [1] as! String, temp[2] as! Int))
                    }
                    callback(true,nested_array)
                }
        }
    }
    
    func newTransaction(self_id: Int, other_id: Int, callback: (Int, Bool) -> ()){
        Alamofire.request(.POST, host_name+"transaction/", parameters: ["user_id_1": self_id,"user_id_2":other_id])
            .responseString(){ (request, response, data, error) in
                if(response?.statusCode != 200 || data == nil || data != "Transaction Successful"){
                    if response == nil {
                        callback(-1,false)
                    } else{
                        callback((response?.statusCode)!,false)
                    }
                } else {
                    callback(200, true)
                }
        }
    }
    
    func getTransactions(userID: Int, callback: (Bool, Array<String>) -> ()){
        Alamofire.request(.GET, host_name+"transaction/"+String(userID))
            .responseJSON { (request,response,data,error) in
                if(response?.statusCode != 200 || data == nil){
                    callback(false,[String]())
                } else {
                    let format_data = (data as! NSArray) as Array
                    var nested_array: Array<String> = [String]()
                    
                    for item in format_data {
                        nested_array.append(item as! String)
                    }
                    callback(true,nested_array)
                }
        }
    }

    
}