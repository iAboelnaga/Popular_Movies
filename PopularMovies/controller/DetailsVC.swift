//
//  DetailsVC.swift
//  PopularMovies
//
//  Created by Aboelnaga on 1/4/20.
//  Copyright © 2020 Aboelnaga. All rights reserved.
//

import UIKit
import CoreData
import Cosmos

class DetailsVC: UIViewController {

    @IBOutlet weak var movName: UILabel!
    @IBOutlet weak var backGroungImg: UIImageView!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var movTitle: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var favMovOutlet: UIButton!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var trairlersTV: UITableView!
    @IBOutlet weak var ratingView: CosmosView!
    
    var movId:Int?
    var obj:Details?
    var trailObj:Trailers?
    var flagForFavourites = 0
    var movieFavourite:[NSManagedObject] = [NSManagedObject]()
    var indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //backGroungImg.addBlurEffect()
        
        ratingView.settings.fillMode = .precise
        
        flagForFavourites = fetchFavoutiteMovies(id:movId ?? 0)
        
        if(flagForFavourites == 0)
        {
            favMovOutlet.tag = 0
            favMovOutlet.setImage(#imageLiteral(resourceName: "empty-heart"), for: .normal)
        }else{
            favMovOutlet.tag = 1
            favMovOutlet.setImage(#imageLiteral(resourceName: "filled-heart"), for: .normal)
        }
        
        fetchMovDetails()
        fetchMovTrailers()
    }
    
    private func fetchMovDetails(){
        APIsRequests.movDetails(mov_id: movId!) { (error:Error?, obj:Details?) in
            if let obj = obj {
                self.obj = obj
            }
            self.setData()
        }
    }
    
    private func fetchMovTrailers(){
        APIsRequests.getTrailers(mov_id: movId!) { (error:Error?, trailObj:Trailers?) in
            if let trailObj = trailObj {
                self.trailObj = trailObj
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.trairlersTV.reloadData()
            }
        }
    }
   
    func setData() {
        DispatchQueue.main.async {
            self.movName.text = self.obj?.title
            self.movTitle.text = self.obj?.originalTitle
            self.duration.text = "\((self.obj?.runtime) ?? 0)min"
            self.genre.text = self.obj?.genres?[0].name
            self.overview.text = self.obj?.overview
            let i:Float = 2.0
            self.ratingView.rating = Double((self.obj?.voteAverage ?? 0.0) / i)
            
            let img = "http://image.tmdb.org/t/p/w185/\(String((self.obj?.backdropPath)!))"
            let imagesUrl = URL(string: img)
            //self.backGroungImg.kf.setImage(with: imagesUrl)
            
            let imgPoster = "http://image.tmdb.org/t/p/w185/\(String((self.obj?.posterPath)!))"
            let imagePosterUrl = URL(string: imgPoster)
            self.posterImg.kf.setImage(with: imagePosterUrl, placeholder: UIImage.init(named: "p.png"))
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func openTrailer(index: Int) {
        if self.trailObj?.results?.count != 0 {
                let appUrl = URL(string: "youtube://\((trailObj?.results?[index].key)!)")
            if UIApplication.shared.canOpenURL(appUrl!) {
                    UIApplication.shared.open(appUrl!)
                } else {
                    let webUrl = URL(string: "https://www.youtube.com/watch?v=\((trailObj?.results?[index].key)!)")
                    UIApplication.shared.open(webUrl!)
                }
            }
    }
    
    func saveFavouriteMovies()
    {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext // return   ns mange object context
        
        
        do{
            let Entity = NSEntityDescription.entity(forEntityName: "MoviesCoreData", in: context!)
            let movie = NSManagedObject(entity: Entity!, insertInto: context)
            
            
            
            if let realimage = self.obj?.posterPath
            {
                movie.setValue(realimage, forKey: "image")
            }
            
            if let backimage = self.obj?.backdropPath
            {
                movie.setValue(backimage, forKey: "background")
            }
            
            let title = self.obj?.title
            movie.setValue(title, forKey: "title")
            
            
            let overview = self.obj?.overview
            movie.setValue(overview, forKey: "overview")
            
            let duration = self.obj?.runtime
            movie.setValue(duration, forKey: "duration")
            
            
            let rating = (self.obj?.voteAverage ?? 0.0) / 2.0
            movie.setValue(rating, forKey: "rate")
            
            
            let id = movId
            movie.setValue(id, forKey: "id")
            
            
            let arrayAsString = trailObj?.results?[0].key
            let stringAsData:Data = ((arrayAsString?.data(using: String.Encoding.utf16)!)!)
            movie.setValue(stringAsData, forKey: "trailers")
            
            
            movieFavourite.append(movie)
            
            try! context?.save()
            
            
        }catch{
            print("error in saving Entity")
        }
    }
    
    func deleteFavouriteMovies()
    {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        
        
        context?.delete(movieFavourite[0])
        movieFavourite.remove(at: 0)
        do{
            try! context!.save()
            
        }catch{
            print("error in delelet")
            
        }
    }

    func fetchFavoutiteMovies(id : Int)->Int
    {
        var flag = 0
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MoviesCoreData")
        
        do {
            movieFavourite = try context!.fetch(fetchRequest)
            for i in movieFavourite
            {
                if let x = i.value(forKey: "id")
                {
                    if x as! Int == id
                    {
                        flag = 1
                        break
                    }else{
                        flag = 0
                    }
                }
                
            }
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return flag
    }
    
    @IBAction func favMov(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            sender.tag = 1
            sender.setImage(#imageLiteral(resourceName: "filled-heart"), for: .normal)
            saveFavouriteMovies()
            
            
        }else{
            sender.tag = 0
            sender.setImage(#imageLiteral(resourceName: "empty-heart"), for: .normal)
            deleteFavouriteMovies()
        }
    }
    @IBAction func backBtn(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
}
extension DetailsVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let  count = (trailObj?.results?.count) else{ return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trailerCell")
        
        cell?.imageView?.image = #imageLiteral(resourceName: "icons8-play-button-100")
        cell?.textLabel?.text = trailObj?.results?[indexPath.row].name
        cell?.textLabel?.textColor = UIColor.init(displayP3Red: 0/255.0, green: 255/255.0, blue: 51/255.0, alpha: 1.0)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openTrailer(index: indexPath.row)
        self.trairlersTV.deselectRow(at: indexPath, animated: true)
    }
}
extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
