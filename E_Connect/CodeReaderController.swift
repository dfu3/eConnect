//
//  CodeReaderController.swift
//  E_Connect
//
//  Created by Zeiger, Carl John on 6/21/15.
//  Copyright © 2015 Merck. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes

class CodeReaderController: RSCodeReaderViewController {
   
    var testCrossField: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        self.cornersLayer.strokeColor = UIColor.redColor().CGColor
        
        let types = NSMutableArray()
        types.addObject(AVMetadataObjectTypeQRCode)
        self.output.metadataObjectTypes = Array(types as Array)
        
        self.barcodesHandler = { barcodes in
            for barcode in barcodes {
                print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                var barcodeString = barcode.stringValue
                if barcodeString.hasPrefix("econnect://") && transactionToBeProcess == false {
                    self.barcodesHandler = nil
                    let someIndex = advance(barcodeString.startIndex,11)
                    otherUserID = barcodeString.substringFromIndex(someIndex)
                    print(otherUserID)
                    transactionToBeProcess = true
                    
                    self.goBack()
                    break
                }
            }
        }
        
    }
    func goBack() {
        //self.session.stopRunning()
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("testSeg", sender: self)
        }
    }
}

