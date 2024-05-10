//
//  FavoritesViewController.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 8.05.2024.
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favoritesTableView: UITableView!
    
        let db = Firestore.firestore()
        var isSearching = false
        var searchArray = [FavoriteNews]()
        var favoriteNews =  [FavoriteNews]()
    
    @IBOutlet weak var newsSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        newsSearchBar.delegate = self
        newsSearchBar.backgroundImage = UIImage()

    }
    
}

extension FavoritesViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        let favoriteNewsItem = favoriteNews[indexPath.row]
        
        cell.titleLabel.text = favoriteNewsItem.title
        cell.descriptionLabel.text = favoriteNewsItem.description
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
    
}

 

extension FavoritesViewController : UISearchBarDelegate {
    
    
}
