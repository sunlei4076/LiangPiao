//
//	RecommentTickes.swift
//
//	Create by Zhang on 22/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class RecommentTickes : NSObject, NSCoding{
    
    var hasNext : Bool!
    //用户读取数据管理
    var nextStart : Int!
    //商家票品管理
    var nextPage : Int!
    
    var showList : [TicketShowModel]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        hasNext = dictionary["has_next"] as? Bool
        nextStart = dictionary["next_start"] as? Int
        nextPage = dictionary["next_page"] as? Int
        showList = [TicketShowModel]()
        if let showListArray = dictionary["show_list"] as? [NSDictionary]{
            for dic in showListArray{
                let value = TicketShowModel(fromDictionary: dic)
                showList.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if hasNext != nil{
            dictionary["has_next"] = hasNext
        }
        if nextStart != nil{
            dictionary["next_start"] = nextStart
        }
        if nextPage != nil{
            dictionary["next_page"] = nextPage
        }
        if showList != nil{
            var dictionaryElements = [NSDictionary]()
            for showListElement in showList {
                dictionaryElements.append(showListElement.toDictionary())
            }
            dictionary["show_list"] = dictionaryElements
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        hasNext = aDecoder.decodeObjectForKey("has_next") as? Bool
        nextStart = aDecoder.decodeObjectForKey("next_start") as? Int
        nextPage = aDecoder.decodeObjectForKey("next_page") as? Int
        showList = aDecoder.decodeObjectForKey("show_list") as? [TicketShowModel]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if hasNext != nil{
            aCoder.encodeObject(hasNext, forKey: "has_next")
        }
        if nextStart != nil{
            aCoder.encodeObject(nextStart, forKey: "next_start")
        }
        if showList != nil{
            aCoder.encodeObject(showList, forKey: "show_list")
        }
        
    }
    
}
