//
//  ProductionCountry.swift
//  PopularMovies
//
//  Created by Aboelnaga on 1/3/20.
//  Copyright © 2020 Aboelnaga. All rights reserved.

import Foundation
import ObjectMapper


class ProductionCountry : NSObject, NSCoding, Mappable{
    
    var iso31661 : String?
    var name : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ProductionCountry()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        iso31661 <- map["iso_3166_1"]
        name <- map["name"]
        
    }

    @objc required init(coder aDecoder: NSCoder)
    {
        iso31661 = aDecoder.decodeObject(forKey: "iso_3166_1") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }

    @objc func encode(with aCoder: NSCoder)
    {
        if iso31661 != nil{
            aCoder.encode(iso31661, forKey: "iso_3166_1")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}
