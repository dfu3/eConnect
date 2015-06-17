//
//  TableManager.swift
//  E_Connect
//
//  Created by Dante Urso on 6/15/15.
//  Copyright (c) 2015 Merck. All rights reserved.
//

import UIKit;

struct task
{
    var name = "";
}

var taskMgr: TaskManager = TaskManager();

class TaskManager: NSObject
{
    var tasks = [task]();
    
    func addTask(name: String) // taskMgr.addTask(stringValue) to add name to listView
    {
        tasks.append(task(name: name));
    }
}

