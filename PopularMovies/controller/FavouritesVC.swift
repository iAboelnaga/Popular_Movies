//
//  FavouritesVC.swift
//  PopularMovies
//
//  Created by Aboelnaga on 1/9/20.
//  Copyright © 2020 Aboelnaga. All rights reserved.
//

import UIKit
import CoreData

class FavouritesVC: UIViewController {

    @IBOutlet weak var favMoviesCV: UICollectionView!
    //@IBOutlet weak var reachabilityView: UIView!
    
    var arrOfFavMov:[NSManagedObject] = [NSManagedObject]()
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoutiteMovies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.title = "Favourites"
    }
    
    func fetchFavoutiteMovies()
    {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        
        let fetching = NSFetchRequest<NSManagedObject>(entityName: "MoviesCoreData")
        
        do
        {
            let myfetching = try context!.fetch(fetching)
            arrOfFavMov = myfetching
        }
        catch
        {
            print("Erorr")
        }
        favMoviesCV.reloadData()
        
    }
}
extension FavouritesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrOfFavMov.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavMovieCell", for: indexPath) as? MovieCell
        
        let posterImage = arrOfFavMov[indexPath.row].value(forKey: "image")as? String
        let img = "http://image.tmdb.org/t/p/w185/\(String((posterImage)!))"
        let imagesUrl = URL(string: img)
        cell?.movImg.kf.setImage(with: imagesUrl, placeholder: UIImage.init(named: "p.png"))
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var VC = DetailsVC()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        VC = storyBoard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        let id = arrOfFavMov[indexPath.row].value(forKey: "id")as? Int
        VC.movId = id
        self.present(VC, animated: true, completion: nil)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = UIScreen.main.bounds.size.width/2
        let h = w * 1.5
        return CGSize(width: w, height: h)
    }
}
