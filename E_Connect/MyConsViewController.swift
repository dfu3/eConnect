//
//  MyConsViewController.swift
//  eConnect
//
//  Created by Urso, Dante F. on 7/28/15.
//  Copyright © 2015 Merck. All rights reserved.
//

import UIKit

class MyConsViewController: UIViewController, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!;
    let databaseInterface = DatabaseInterface();
    var refreshControl:UIRefreshControl!;
    
    var tempArr = [String]();
    var loadArr = [String]();
    
    
    override func viewDidAppear(animated: Bool)
    {
        buildData();
//        
//        for (var i = 0; i < tempArr.count; i++)
//        {
//            if(i % 2 == 0)
//            {
//                loadArr.append(tempArr[i]);
//            }
//        }
        
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        print("in table View");
        
        //print(self.tempArr);

        tempArr = Array(Set(tempArr));
        
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"cell");
        cell.textLabel?.text = self.tempArr[indexPath.row];
        
        return cell;
    }

    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        tableView.dataSource = self;
        
        self.refreshControl = UIRefreshControl();
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh");
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged);
        self.tableView.addSubview(refreshControl);
        
        //print("in viewdidload");
        
        
        // Do any additional setup after loading the view.
    }
    
    func refresh(sender:AnyObject)
    {
        buildData();
    }

    
    func buildData()
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        
        var userID: Int = -1;
        
        if let i = (defaults.valueForKey("user_id") as? Int)
        {
            userID = i;
        }
        
        let networkLoadingAlert = UIAlertController(title: "Loading...\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.Alert);
        
        let callback =
        {
            (success: Bool, myArr: Array<String>) -> () in networkLoadingAlert.dismissViewControllerAnimated(false, completion: nil);
            
            print("start callback");
            
            
            if(myArr != self.tempArr)
            {
                for element in myArr
                {
                    //print(element);
                    self.tempArr.append(element);
                }
            }
        }
        
        self.tableView.reloadData();
        self.refreshControl.endRefreshing();
        
        self.presentViewController(networkLoadingAlert, animated: false, completion: nil)
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
        {
                self.databaseInterface.getTransactions(userID, callback: callback);
        }

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        tempArr = Array(Set(tempArr));
        return self.tempArr.count;
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
