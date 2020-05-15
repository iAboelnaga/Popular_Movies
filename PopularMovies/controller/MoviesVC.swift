//
//  ViewController.swift
//  PopularMovies
//
//  Created by Aboelnaga on 1/2/20.
//  Copyright © 2020 Aboelnaga. All rights reserved.
//

import UIKit
import Kingfisher
import BTNavigationDropdownMenu

class MoviesVC: UIViewController {

    @IBOutlet weak var moviesCV: UICollectionView!
    @IBOutlet weak var reachabilityView: UIView!
    
    var obj : Movies?
    let items = ["Most Popular", "Top Rated"]
    var indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reachabilityView.isHidden = true
        if Reachability.isConnectedToNetwork() == true
        {
            fetchMostPopular()
        }
        else
        {
            reachabilityView.isHidden = false
        }
        
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 0/255.0, green: 180/255.0, blue: 220/255.0, alpha: 1.0)

        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("Most Popular"), items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        //menuView.cellSelectionColor = UIColor.init(displayP3Red: 0/255.0, green: 160/255.0, blue: 195/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.init(displayP3Red: 0/255.0, green: 255/255.0, blue: 51/255.0, alpha: 1.0)
        menuView.cellTextLabelFont = UIFont.init(name: "Avenir-Heavy", size: 17)
        menuView.arrowPadding = 10
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            if indexPath == 0
            {
                self?.fetchMostPopular()
            }
            else if indexPath == 1
            {
                self?.fetchTopRated()
            }
            
        }
    }
    
    private func fetchMostPopular(){
        APIsRequests.popularMov { (error:Error?, obj:Movies?) in
            if let obj = obj {
                self.obj = obj
                self.moviesCV.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    private func fetchTopRated(){
        APIsRequests.topRatedMov { (error:Error?, obj:Movies?) in
            if let obj = obj {
                self.obj = obj
                self.moviesCV.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
//:- Mark-Collection
extension MoviesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let  count = (obj?.results?.count) else{ return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell
        
        let img = "http://image.tmdb.org/t/p/w185/\(String((obj?.results?[indexPath.row].posterPath)!))"
        let imagesUrl = URL(string: img)
        cell?.movImg.kf.setImage(with: imagesUrl, placeholder: UIImage.init(named: "p.png"))
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var VC = DetailsVC()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        VC = storyBoard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        VC.movId = obj?.results?[indexPath.row].id
        self.present(VC, animated: true, completion: nil)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = UIScreen.main.bounds.size.width/2
        let h = w * 1.5
        return CGSize(width: w, height: h)
    }
}
