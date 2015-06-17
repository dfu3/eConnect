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
    var name = "no name";
}

var taskMgr: TaskManager = TaskManager();

class TaskManager: NSObject
{
    var tasks = [task]();
    
    func addTask(name: String)
    {
        tasks.append(task(name: name));
    }
}

