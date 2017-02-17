//
//  MovieViewController.swift
//  Flick
//
//  Created by Nguyen Trong Khoi on 2/14/17.
//  Copyright © 2017 Nguyen Trong Khoi. All rights reserved.
//

import UIKit
import MBProgressHUD
class MovieViewController: UIViewController  {

    @IBOutlet weak var moviesTableView: UITableView!
    let refeshcontrol = UIRefreshControl()
    
    
    
    var itemsList = [[String : AnyObject]] ()
    var moviceItems = [Int : Movie]()
    var url: URL?
    var  errorView: UIView?
    
      
    
    override open func viewDidLoad(){
        
         url  = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        fetchItemsList()
        
        refeshcontrol.addTarget(self, action: #selector(MovieViewController.fetchItemsList), for: UIControlEvents.valueChanged)
        moviesTableView.addSubview(refeshcontrol)
        createNetworkErrorView()
        
       
        displayUIbyNetworkStage()
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "moviedetailSegue") {
            let detailVC: MovieDetailViewController = segue.destination as! MovieDetailViewController
            if let indexpath = moviesTableView.indexPathForSelectedRow{
                detailVC.movie = self.moviceItems[indexpath.section]!
            }

        }
     }
    
     func fetchItemsList(){
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        Movie.getMoviesList(link: url! , callback: { (items) -> (Void) in
            self.itemsList += items
            DispatchQueue.main.async(execute: {
                self.moviesTableView?.reloadData()
                self.refeshcontrol.endRefreshing()
              
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        })
        

    }
    
    fileprivate func displayUIbyNetworkStage(){
        
        if(hasInternetConnection()){
            print("dasdasfsf")
            errorView?.isHidden = false
        }else{
            print("false")

        }
    
    }
    
    
    fileprivate func createNetworkErrorView()
    {
        let errorViewFrame : CGRect = CGRect(x: 0, y: 60, width: 320, height: 30)
        var  errorView: UIView = UIView(frame: errorViewFrame)
        errorView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        let errorMessage = UILabel(frame: CGRect(x: 0, y: 0, width: errorView.frame.width, height: errorView.frame.height))
        errorMessage.textColor = UIColor.white
        errorMessage.textAlignment = .center
        errorMessage.text = "network error"
        errorView.addSubview(errorMessage)
        
        self.view.addSubview(errorView)
        
    }
}


extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MovieCell
        cell.resetCell()
        if let movie = moviceItems[indexPath.section]{
            cell.setupCell(movieItem: movie)
        }else{
            Movie.object(at: (indexPath.section), fromList: itemsList, callback: { (movie, index) in
                self.moviceItems[index] = movie
                DispatchQueue.main.async(execute: {
                    self.moviesTableView?.reloadData()
                })
            })
        }
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.gray.cgColor
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemsList.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    

    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let movie = self.moviceItems[indexPath.section]
        performSegue(withIdentifier: "moviedetailSegue", sender: movie)
    }
    
   
    
    
}

