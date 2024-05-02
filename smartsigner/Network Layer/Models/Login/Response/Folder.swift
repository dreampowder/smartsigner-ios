//
//	Folder.swift
//
//	Create by Serdar Coşkun on 20/9/2018
//	Copyright © 2018 coskun.serdar@gmail.com. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Folder:TreeNodeProtocol{
    
    //TreeNodeProtocol Properties
    var identifier: String
    
    var isExpandable: Bool
    
    var folderLevel:Int = 0
    //TreeNodeProtocol Properties - End

	var documentCount : Int!
	var children : [Folder]!
	var id : String!
	var parentId : String!
	var text : String!

    //Serdar Coskun
    func getFlatList()->[Folder]{
        var flatList:[Folder] = []
        if self.children.count == 0{
            flatList.append(self)
        }else{
            var childrenArray:[Folder] = []
            for index in 0..<self.children.count{
                let child = self.children[index]
                childrenArray.append(contentsOf: child.getFlatList())
            }
            self.children = []
            flatList.append(self)
            flatList.append(contentsOf: childrenArray)
        }
        return flatList
    }
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		documentCount = dictionary["DocumentCount"] as? Int
		children = [Folder]()
		if let childrenArray = dictionary["children"] as? [[String:Any]]{
			for dic in childrenArray{
                let value = Folder(fromDictionary: dic,level:folderLevel+1)
				children.append(value)
			}
		}
		id = dictionary["id"] as? String
		parentId = dictionary["parentId"] as? String
		text = dictionary["text"] as? String
        
        
        self.identifier = id
        self.isExpandable = self.children.count>0
	}

    init(fromDictionary dictionary: [String:Any], level:Int){
        folderLevel = level
        documentCount = dictionary["DocumentCount"] as? Int
        children = [Folder]()
        if let childrenArray = dictionary["children"] as? [[String:Any]]{
            for dic in childrenArray{
                let value = Folder(fromDictionary: dic,level:folderLevel+1)
                children.append(value)
            }
        }
        id = dictionary["id"] as? String
        parentId = dictionary["parentId"] as? String
        text = dictionary["text"] as? String
        
        
        self.identifier = id
        self.isExpandable = self.children.count>0
        
    }
    
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if documentCount != nil{
			dictionary["DocumentCount"] = documentCount
		}
		if children != nil{
			var dictionaryElements = [[String:Any]]()
			for childrenElement in children {
				dictionaryElements.append(childrenElement.toDictionary())
			}
			dictionary["children"] = dictionaryElements
		}
		if id != nil{
			dictionary["id"] = id
		}
		if parentId != nil{
			dictionary["parentId"] = parentId
		}
		if text != nil{
			dictionary["text"] = text
		}
		return dictionary
	}

}
