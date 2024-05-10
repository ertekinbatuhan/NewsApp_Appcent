//
//  FavoritesViewController.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 8.05.2024.
//

import UIKit
import Firebase
import Kingfisher

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favoritesTableView: UITableView!
    
        let db = Firestore.firestore()
        var isSearching = false
        var searchArray = [News]()
        var favoriteNews =  [News]()
        var favoritesViewModel = FavoritesViewModel()
      
    @IBOutlet weak var favoriteSearchBar: UISearchBar!
    
    @IBOutlet weak var newsSearchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        newsSearchBar.delegate = self
        newsSearchBar.backgroundImage = UIImage()
        
        favoriteSearchBar.placeholder = "Search"
        
        _ = favoritesViewModel.newsItemsArray.subscribe(onNext: { data in
            
            self.favoriteNews = data
            DispatchQueue.main.async {
                
                self.favoritesTableView.reloadData()
            }
        })
    }
}

extension FavoritesViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            
            return  searchArray.count
        } else {
            return favoriteNews.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        let favoriteNewsItem = favoriteNews[indexPath.row]
        
        cell.titleLabel.text = favoriteNewsItem.title
        cell.descriptionLabel.text = favoriteNewsItem.description
        cell.titleLabel.numberOfLines = 0
        cell.descriptionLabel.numberOfLines = 0
        
        cell.titleLabel.font  = .systemFont(ofSize: 25,weight: .semibold)
        cell.descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
        cell.newsImageView.layer.cornerRadius = 6
        cell.newsImageView.layer.masksToBounds = true
        cell.newsImageView.contentMode = .scaleAspectFill
        cell.newsImageView.backgroundColor = .secondarySystemBackground
        cell.newsImageView.clipsToBounds = true
        
        if let imageUrl = URL(string: favoriteNewsItem.urlToImage ?? "") {
            
            cell.newsImageView.kf.setImage(with: imageUrl)
        }
        
        if isSearching {
            let newsItem = searchArray[indexPath.row]
            cell.titleLabel.text = newsItem.title
            cell.descriptionLabel.text = newsItem.description
            if let imageUrl = URL(string: newsItem.urlToImage ?? "") {
                cell.newsImageView.kf.setImage(with: imageUrl)
            }
            
        } else {
            
            let newsItem = favoriteNews[indexPath.row]
            cell.titleLabel.text = newsItem.title
            cell.descriptionLabel.text = newsItem.description
            if let imageUrl = URL(string: newsItem.urlToImage ?? "") {
                cell.newsImageView.kf.setImage(with: imageUrl)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedNews : News?
        
        if isSearching {
            
            selectedNews = searchArray[indexPath.row]
            
        } else {
            
            selectedNews = favoriteNews[indexPath.row]
        }
        
            performSegue(withIdentifier: "favoriteToDetails", sender: selectedNews)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteToDetails" {
            if let selectedNews = sender as? News {
                if let detailsVC = segue.destination as? NewsDetailsViewController {
                    detailsVC.selectedNews = selectedNews
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension FavoritesViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
                  isSearching = false
                  
              } else {
                  isSearching = true
                  searchArray = favoriteNews.filter({$0.title.lowercased().contains(searchText.lowercased())})
              }
              self.favoritesTableView.reloadData()
          }
    }

