//
//  ProductionCompany.swift
//  PopularMovies
//
//  Created by Aboelnaga on 1/3/20.
//  Copyright © 2020 Aboelnaga. All rights reserved.

import Foundation
import ObjectMapper


class ProductionCompany : NSObject, NSCoding, Mappable{
    
    var id : Int?
    var logoPath : String?
    var name : String?
    var originCountry : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ProductionCompany()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        logoPath <- map["logo_path"]
        name <- map["name"]
        originCountry <- map["origin_country"]
        
    }

    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        logoPath = aDecoder.decodeObject(forKey: "logo_path") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        originCountry = aDecoder.decodeObject(forKey: "origin_country") as? String
        
    }

    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if logoPath != nil{
            aCoder.encode(logoPath, forKey: "logo_path")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if originCountry != nil{
            aCoder.encode(originCountry, forKey: "origin_country")
        }
        
    }
    
}
