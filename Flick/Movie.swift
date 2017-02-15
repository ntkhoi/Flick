//
//  Movie.swift
//  Flick
//
//  Created by Nguyen Trong Khoi on 2/15/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import Foundation

class Movie{
    
    let title:String
    let overview: String
    let imageUrl: String
    
    init(title: String , overview : String , imageUrl : String){
        self.title = title
        self.overview = overview
        self.imageUrl = imageUrl
    }
    
    // Desetrolize JSON
    class func getMoviesList(link: URL, callback: @escaping ([[String : AnyObject]]) -> (Void)) {
        var items = [[String : AnyObject]]()
        URLSession.shared.dataTask(with: link) { (data, response, error) in
            if error != nil {
                
            } else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    items = json["results"] as! [[String : AnyObject]]
                } catch _ {
                   
                }
                 callback(items)
            }
            
        }.resume()
    }
    
    
    class func object(at: Int, fromList: Array<[String : AnyObject]>, callback: @escaping ((Movie, Int) -> Void))  {
        let  baseUrl = "https://image.tmdb.org/t/p/w300"

        DispatchQueue.global(qos: .userInteractive).async(execute: {
            let item = fromList[at]
            let title  = item["title"] as! String
            let overview = item["overview"] as! String
            let imageUrl = "\(baseUrl)\(item["poster_path"] as! String)"
            let movie = Movie.init(title: title, overview: overview, imageUrl: imageUrl)
            
            callback(movie, at)
        })
    }

    
}
