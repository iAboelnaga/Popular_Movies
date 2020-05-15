//
//  SpokenLanguage.swift
//  PopularMovies
//
//  Created by Aboelnaga on 1/3/20.
//  Copyright © 2020 Aboelnaga. All rights reserved.

import Foundation
import ObjectMapper


class SpokenLanguage : NSObject, NSCoding, Mappable{
    
    var iso6391 : String?
    var name : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return SpokenLanguage()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        iso6391 <- map["iso_639_1"]
        name <- map["name"]
        
    }

    @objc required init(coder aDecoder: NSCoder)
    {
        iso6391 = aDecoder.decodeObject(forKey: "iso_639_1") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }

    @objc func encode(with aCoder: NSCoder)
    {
        if iso6391 != nil{
            aCoder.encode(iso6391, forKey: "iso_639_1")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}
