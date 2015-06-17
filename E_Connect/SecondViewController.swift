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
    
    
    @IBOutlet weak var name: UITextField!;
    
    @IBOutlet weak var barCodeView: UIImageView!;
    weak var barCodeIMG: UIImage!;
    
    @IBAction func goToScan(sender: UIButton) // opens up camera view to scan another barcode
    {
        //code
        print("scanning \n");
        
    }
    
    
    @IBAction func getName(sender: UIButton) // will send the name to the server to be queued
    {
        print("name: " + name.text + "\n");
        //taskMgr.addTask(name.text);
        self.view.endEditing(true);
        name.text = "";
        
        let barCode = fromString("9999");
        
        barCodeView.image = barCode;
        barCodeIMG = barCode;
        barCodeView.layer.cornerRadius = 12;
        barCodeView.layer.masksToBounds = true;
    }
    
    func fromString(string : String) -> UIImage? // returns barcode image
    {
        
        let data = string.dataUsingEncoding(NSASCIIStringEncoding);
        let filter = CIFilter(name: "CICode128BarcodeGenerator");
        filter.setValue(data, forKey: "inputMessage");
        return UIImage(CIImage: filter.outputImage);
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        barCodeView.image = barCodeIMG;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
    
}
