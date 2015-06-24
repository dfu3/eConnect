import UIKit
import CoreImage
import Foundation
import RSBarcodes
import AVFoundation

var otherUserID: String?
var transactionToBeProcess: Bool = false
var barcodeFound: (() -> ())?

class SecondViewController: UIViewController, UITextFieldDelegate{
    
    var userName: String?
    var safeUserID: Int?
    var safeUserName: String?
    let databaseInterface = DatabaseInterface()

    
    //MARK: Outlets
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBAction func returnToStepOne(segue: UIStoryboardSegue){
    }
    struct userInfo {
        static let username = "username"
        static let ID = "user_id"
    }
    
    //MARK: Actions
    //This action should verify that the entered name is correct, display a dialouge to promt a confirmation of the name, and then edit the label to show the user's name and hide the text field and button.
    @IBAction func enterButtonAction(sender: UIButton) {
        nameTextField.resignFirstResponder()
        let allowedChars: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz";
        var badChar = false;
        for letter in nameTextField.text!.characters{
            if ( allowedChars.rangeOfString(String(letter)) == nil ){
                badChar = true;
                break;
            }
        }
        if(badChar){
            showErrorMessage("Your name can only contain alphebetical charecters")
            return
        }
        showConfirmationAlert()
    }
    
    //This action should pop up the scanner view
    @IBAction func scanButtonAction(sender: UIButton) {
        transactionToBeProcess = false
        performSegueWithIdentifier("betweenOneAndTwo", sender: self)
        
    }
    
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        userName = nameTextField.text
    }
    
    override func viewDidAppear(animated: Bool) {
        if transactionToBeProcess {
            dispatch_async(dispatch_get_main_queue()){
                self.createTransaction()
            }
        }
        if safeUserID != nil && safeUserID != -1{
            dispatch_async(dispatch_get_main_queue()){
                self.updateCount()
            }
        }
    }
    //We have to try and make this method load ASAP to improve UX quality
    override func viewDidLoad(){
        super.viewDidLoad();
        
        //for testing purposes to clear the defaults
        //let d = NSUserDefaults.standardUserDefaults()
        //d.removeObjectForKey(userInfo.username)
        //d.removeObjectForKey(userInfo.ID)
        //d.synchronize()
        //end tesing vars
        
        nameTextField.delegate = self
        dispatch_async(dispatch_get_main_queue()){
            let gen = RSUnifiedCodeGenerator.shared
            gen.fillColor = UIColor.whiteColor()
            gen.strokeColor = UIColor.blackColor()
            let image: UIImage? = gen.generateCode("econnect://-1", machineReadableCodeObjectType: AVMetadataObjectTypeQRCode)
            if let i = image {
                self.codeImageView.image = RSAbstractCodeGenerator.resizeImage(i, scale: (self.view.frame.width - 100.0)/i.size.height)
            }
            let defaults = NSUserDefaults.standardUserDefaults()
            if let u = defaults.valueForKey(userInfo.username) as? String{
                self.safeUserName = u
            }
            if let i = (defaults.valueForKey(userInfo.ID) as? Int) {
                self.safeUserID = i
            }
            
            if self.safeUserName != nil && self.safeUserID != nil {
                self.generateBarcode()
                self.updateCount()
            } else {
                self.scanButton.hidden = true
            }
        }
    }
    
    // 1. We show the confirmation alert. If OK is pressed, we call registerUserWithServer
    // 2. If we get a success bool, store the information with setSavedUsernameandID, but if we get a fail bool show an error message and do nothing else.
    func showConfirmationAlert(){
        let refreshAlert = UIAlertController(title: "Confirmation", message: "Are you sure you want to set your name as \"" + userName! + "\"", preferredStyle: UIAlertControllerStyle.Alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.registerUserWithServer()
            
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    func registerUserWithServer(){
        let networkLoadingAlert = UIAlertController(title: "Loading...\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let callback = {(returnedID: Int, success: Bool) -> () in
            networkLoadingAlert.dismissViewControllerAnimated(false, completion: nil)
            if success{
                self.setSavedUsernameAndID(self.userName!, id: returnedID)
            } else {
                self.showErrorMessage("There was a network or server error. Please check your network status and try again")
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(networkLoadingAlert, animated: false, completion: nil)
            self.databaseInterface.registerNewUser(self.userName!, callback: callback)
        }
        
        
        
    }
    
    func showErrorMessage(message: String){
        let alert = UIAlertController(title: "An Error Has Occured", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        dispatch_async(dispatch_get_main_queue(), {() -> () in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        dispatch_async(dispatch_get_main_queue(), {() -> () in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func setSavedUsernameAndID(username: String, id: Int){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(id, forKey: userInfo.ID)
        defaults.setValue(username, forKey: userInfo.username)
        defaults.synchronize()
        
        safeUserName = username
        safeUserID = id
        generateBarcode()
    }
    
    func generateBarcode(){
        let gen = RSUnifiedCodeGenerator.shared
        gen.fillColor = UIColor.whiteColor()
        gen.strokeColor = UIColor.blackColor()
        let image: UIImage? = gen.generateCode("econnect://\(safeUserID!)", machineReadableCodeObjectType: AVMetadataObjectTypeQRCode)
        if let i = image {
            self.codeImageView.image = RSAbstractCodeGenerator.resizeImage(i, scale: (self.view.frame.width - 100.0)/i.size.height)
        }
        welcomeLabel.text = "Hi, \(safeUserName!)"
        nameTextField.hidden = true
        enterButton.hidden = true
        scanButton.hidden = false
        
    }
    
    func createTransaction(){
        
        let otherID = Int(otherUserID!)
        if otherID == -1 {
            self.showMessage("Oops", message: "The other user has not set up their app yet.")
            transactionToBeProcess = false
            return
        }
        let networkLoadingAlert = UIAlertController(title: "Loading...\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let callback = {(statuscode: Int, success: Bool) -> () in
            networkLoadingAlert.dismissViewControllerAnimated(false, completion: nil)
            if success{
                self.showMessage("Success", message: "You have successfully met another user")
                self.updateCount()
            } else if statuscode == 406{
                self.showMessage("Hold Up!", message:"You've already met this person.")
            } else {
                self.showErrorMessage("There was a network or server error. Please check your network status and try again")
            }
        }
        if let id = otherID {
            self.presentViewController(networkLoadingAlert, animated: false, completion: nil)
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)){
                self.databaseInterface.newTransaction(self.safeUserID!, other_id: id, callback: callback)
            }
        } else {
            showErrorMessage("Unable to process scanned QRCode")
            return
        }
        transactionToBeProcess = false
    }
    func updateCount(){
        let callback = {(count: Int) -> () in
            dispatch_async(dispatch_get_main_queue()){
                self.welcomeLabel.text = "Hi, \(self.safeUserName!). You have made \(count) connections."
            }
        }
        if let id = safeUserID{
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)) {
                self.databaseInterface.getUserCount(id, callback: callback)
            }
        }
    }
    
}
