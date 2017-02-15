//
//  MovieViewController.swift
//  Flick
//
//  Created by Nguyen Trong Khoi on 2/14/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var moviesTableView: UITableView!
    
    var itemsList = [[String : AnyObject]] ()
    var moviceItems = [Int : Movie]()

    
    override open func viewDidLoad(){
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        fetchItemsList(link: URL.init(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MovieCell
        cell.resetCell()
        if let movie = moviceItems[indexPath.row]{
            cell.setupCell(movieItem: movie)
        }else{
            Movie.object(at: (indexPath.row), fromList: itemsList, callback: { (movie, index) in
                self.moviceItems[index] = movie
                DispatchQueue.main.async(execute: {
                    self.moviesTableView?.reloadData()
                })
            })
        }
        return cell
    }
    
    fileprivate func fetchItemsList(link :URL){
        Movie.getMoviesList(link: link , callback: { (items) -> (Void) in
            self.itemsList += items
            DispatchQueue.main.async(execute: {
                self.moviesTableView?.reloadData()
            })
        })
    }
}

