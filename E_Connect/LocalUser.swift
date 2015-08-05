//
//  LocalUser.swift
//  eConnect
//
//  Created by Urso, Dante F. on 7/29/15.
//  Copyright © 2015 Merck. All rights reserved.
//

import UIKit

class LocalUser: NSObject
{
    func setUser(name: String, ID: Int)
    {
//        
//        let userInfo = name + "@" + String(ID);
//        
//        let file = "eConnectUserInfo.txt";
//        
//        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
//        {
//            let dir = dirs[0]; //documents directory
//            let path = dir.stringByAppendingPathComponent(file);
//            
//            let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: path)
//            
//            if file == nil
//            {
//                print("File open failed");
//            }
//            else
//            {
//                let data = (userInfo as NSString).dataUsingEncoding(NSUTF8StringEncoding);
//                file?.writeData(data!);
//                file?.closeFile();
//            }
//        
//        }
        
    }
    
    func getUserName() -> String
    {
        return "name";
    }
    
    func getUserID() -> Int
    {
        return -1;
    }

}
