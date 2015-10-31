//
//  DataModel.swift
//  Checklists
//
//  Created by 超平 谢 on 15/6/16.
//  Copyright (c) 2015年 超平 谢. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init(){
        loadChecklists()
        registerDefaults()
        handleFirstIime()
    }
    
    func loadChecklists(){
        let path = dataFilePath()
        println(path)
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            if let data = NSData(contentsOfFile: path){
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists") as [Checklist]
                unarchiver.finishDecoding()
                sortChecklists()
            }
        }
        
    }
    
    
   class func nextChecklistItemID() -> Int{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        userDefaults.setInteger(itemID+1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    func documentDirectory()->String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }
    
    func dataFilePath()->String{
        return documentDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
    
    
    func saveChecklists(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func registerDefaults() {
        let dictionary = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func handleFirstIime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
        }
    }
    
    func sortChecklists(){
        lists.sort({checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == NSComparisonResult.OrderedAscending})
    }
    
    
}