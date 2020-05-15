//
//  Trailers.swift
//  PopularMovies
//
//  Created by Aboelnaga on 1/8/20.
//  Copyright © 2020 Aboelnaga. All rights reserved.
//

import Foundation
import ObjectMapper


class Trailers : NSObject, NSCoding, Mappable{
    
    var id : Int?
    var results : [TrailersData]?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Trailers()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        results <- map["results"]
        
    }

    required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        results = aDecoder.decodeObject(forKey: "results") as? [TrailersData]
        
    }

    func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if results != nil{
            aCoder.encode(results, forKey: "results")
        }
        
    }
    
}
