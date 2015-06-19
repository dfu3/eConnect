//
//  SecondViewController.swift
//  E_Connect
//
//  Created by Dante Urso on 6/15/15.
//  Copyright (c) 2015 Merck. All rights reserved.
//

import UIKit;
import CoreImage;

class SecondViewController: UIViewController, UITextFieldDelegate
{
    
    
    @IBOutlet weak var nameDisplay: UILabel!;
    
    @IBOutlet weak var name: UITextField!;
    
    @IBOutlet weak var barCodeView: UIImageView!;
    
    @IBAction func goToScan(sender: UIButton) // opens up camera view to scan another barcode
    {
        // load scanner
        
    }
    
    
    @IBAction func getName(sender: UIButton) // will send the name to the server to be queued
    {
        
        var GUID = "9999";
        let allowedChars: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz";
        var badChar = false;
        
        if( barCodeHouse.curVal == "0000") // if first time entering name
        {
            for letter in name.text!.characters
            {
                if ( allowedChars.rangeOfString(String(letter)) == nil ) // check for valid name
                {
                    badChar = true;
                    break;
                }
                
            }
            
            if(badChar) // alert mess
            {
                var alert = UIAlertController(title: "Invalid Name Iput", message: "A,a - Z,z Only", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            else
            {
                //taskMgr.addTask(name.text);
                self.view.endEditing(true);
                
                let barCode = BarCodeGen.fromString(GUID);
                
                barCodeHouse.addCode(barCode!, GUID: GUID);
                barCodeView.image = barCode;
                
                barCodeView.layer.cornerRadius = 12;
                barCodeView.layer.masksToBounds = true;
                
                name.placeholder = "Account Active";
                nameDisplay.text = name.text;
            }
            
        }
        
        else // alert mess
        {
            var alert = UIAlertController(title: "Account Active", message: "You Have Already Entered A Name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        name.text = "";
    }

    override func viewDidLoad()
    {
        super.viewDidLoad();
        let localImage = barCodeHouse.barCode
        barCodeView.image = barCodeHouse.barCode;
        
        barCodeView.layer.cornerRadius = 12;
        barCodeView.layer.masksToBounds = true;
        
        let interface = DatabaseInterface()
        var returnedID: Int?
        let callbackFunction = {(localId: Int) -> Void in
            returnedID = localId
        }
        
        interface.getLeaderBoard({(response: Array<(Int,String,Int)>) -> () in
            
        })
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
    
}
