//
//  Movies.swift
//  PopularMovies
//
//  Created by Aboelnaga on 1/2/20.
//  Copyright © 2020 Aboelnaga. All rights reserved.
//

import Foundation
import ObjectMapper


class Movies : NSObject, NSCoding, Mappable{
    
    var page : Int?
    var results : [Result]?
    var totalPages : Int?
    var totalResults : Int?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Movies()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        page <- map["page"]
        results <- map["results"]
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
        
    }

    @objc required init(coder aDecoder: NSCoder)
    {
        page = aDecoder.decodeObject(forKey: "page") as? Int
        results = aDecoder.decodeObject(forKey: "results") as? [Result]
        totalPages = aDecoder.decodeObject(forKey: "total_pages") as? Int
        totalResults = aDecoder.decodeObject(forKey: "total_results") as? Int
        
    }

    func encode(with aCoder: NSCoder)
    {
        if page != nil{
            aCoder.encode(page, forKey: "page")
        }
        if results != nil{
            aCoder.encode(results, forKey: "results")
        }
        if totalPages != nil{
            aCoder.encode(totalPages, forKey: "total_pages")
        }
        if totalResults != nil{
            aCoder.encode(totalResults, forKey: "total_results")
        }
        
    }
    
}
