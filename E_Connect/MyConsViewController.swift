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
    
    var data: [String] = ["Loading ..."]
    
    
    override func viewDidAppear(animated: Bool)
    {
        buildData();
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: nil);
        cell.textLabel?.text = data[indexPath.row];
        
        return cell;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data.count
        
    }

    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        tableView.dataSource = self;
        
        self.refreshControl = UIRefreshControl();
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh");
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged);
        self.tableView.addSubview(refreshControl)
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
        
        let callback =
        {
            (success: Bool, myArr: Array<String>) -> () in
            dispatch_async(dispatch_get_main_queue()){
                self.data = [String]()
                if success {
                    for name in myArr{
                        var str: String = name
                        if str.characters.count > 26{
                            let someIndex=advance(str.startIndex, 26)
                            str = str.substringToIndex(someIndex)
                            str = str + "..."
                        }
                        self.data.append(str)
                    }
                } else {
                    let str = "Network Error"
                    self.data.append(str)
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        
            self.tableView.reloadData();
            self.refreshControl.endRefreshing();
        }
        databaseInterface.getTransactions(userID, callback: callback)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
