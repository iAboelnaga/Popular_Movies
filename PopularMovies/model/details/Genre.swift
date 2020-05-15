//
//  Genere.swift
//  PopularMovies
//
//  Created by Aboelnaga on 1/3/20.
//  Copyright © 2020 Aboelnaga. All rights reserved.

import Foundation
import ObjectMapper


class Genre : NSObject, NSCoding, Mappable{
    
    var id : Int?
    var name : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Genre()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["name"]
        
    }

    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }

    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}
