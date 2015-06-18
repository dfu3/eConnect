//
//  BarCodeHouse.swift
//  E_Connect
//
//  Created by Dante Urso on 6/17/15.
//  Copyright (c) 2015 Merck. All rights reserved.
//

import UIKit

var barCodeHouse: BarCodeHouse = BarCodeHouse();

class BarCodeGen
{
    static func fromString(string : String) -> UIImage? // returns barcode image
    {
        
        let data = string.dataUsingEncoding(NSASCIIStringEncoding);
        let filter = CIFilter(name: "CICode128BarcodeGenerator");
        filter!.setValue(data, forKey: "inputMessage");
        return UIImage(CIImage: filter!.outputImage);
        
    }
    
}

class BarCodeHouse: NSObject
{
    var curVal: String = "";
    var barCode: UIImage;
    
    override init()
    {
        curVal = "0000";
        barCode = BarCodeGen.fromString(curVal)!;
        
    }
    func addCode(code: UIImage, GUID: String)
    {
        barCode = code;
        curVal = GUID;
    }
    
    func getCode() -> UIImage
    {
        return barCode;
    }
}
