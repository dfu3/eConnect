//
//  FirstViewController.swift
//  E_Connect
//
//  Created by Dante Urso on 6/15/15.
//  Copyright (c) 2015 Merck. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    //@IBOutlet weak var tableTasks: UITableView!
    
    
    @IBOutlet weak var leaderBd: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        leaderBd.reloadData();
    }
    
    //---------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return taskMgr.tasks.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test");
        
        cell.textLabel?.text = taskMgr.tasks[indexPath.row].name;
        //cell.detailTextLabel!.text = taskMgr.tasks[indexPath.row].desc;
        
        
        return cell;
    }
    
}
