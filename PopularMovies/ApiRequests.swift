//
//  ApiRequests.swift
//  PopularMovies
//
//  Created by Aboelnaga on 1/2/20.
//  Copyright © 2020 Aboelnaga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import AlamofireObjectMapper

class APIsRequests: NSObject {
    
    class func popularMov( completion:@escaping(_ _error:Error?, _ obj:Movies?)->Void){
        let url = "http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=8004441caa19638a8eb3ee9876b60817"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode:200..<300).responseObject(completionHandler: { (response: DataResponse<Movies>) in
                switch response.result
                {
                case.failure(let error):
                    completion(error, nil)
                    print(error)
                case.success(let value):
                    completion(nil, response.result.value)
                }
            })
    }
    
    class func topRatedMov( completion:@escaping(_ _error:Error?, _ obj:Movies?)->Void){
        let url = "http://api.themoviedb.org/3/discover/movie?certification_country=US&certification=R&sort_by=vote_average.desc&api_key=8004441caa19638a8eb3ee9876b60817"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode:200..<300).responseObject(completionHandler: { (response: DataResponse<Movies>) in
                switch response.result
                {
                case.failure(let error):
                    completion(error, nil)
                    print(error)
                case.success(let value):
                    completion(nil, response.result.value)
                }
            })
    }
    
    class func movDetails(mov_id:Int, completion:@escaping(_ _error:Error?, _ obj:Details?)->Void){
        let url = "https://api.themoviedb.org/3/movie/\(mov_id)?api_key=8004441caa19638a8eb3ee9876b60817"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode:200..<300).responseObject(completionHandler: { (response: DataResponse<Details>) in
                switch response.result
                {
                case.failure(let error):
                    completion(error, nil)
                    print(error)
                case.success(let value):
                    completion(nil, response.result.value)
                }
            })
    }

    class func getTrailers(mov_id:Int, completion:@escaping(_ _error:Error?, _ obj:Trailers?)->Void){
        let url = "https://api.themoviedb.org/3/movie/\(mov_id)/videos?api_key=8004441caa19638a8eb3ee9876b60817"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode:200..<300).responseObject(completionHandler: { (response: DataResponse<Trailers>) in
                switch response.result
                {
                case.failure(let error):
                    completion(error, nil)
                    print(error)
                case.success(let value):
                    completion(nil, response.result.value)
                }
            })
    }
}
