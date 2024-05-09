//
//  ViewController.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 8.05.2024.
//

import UIKit
import Kingfisher




class MainViewController: UIViewController {
    

    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var newsSearchBar: UISearchBar!
    private var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        newsSearchBar.delegate = self 
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        APICaller.shared.getNewsStories{ [weak self]  result in
                    switch result {
                    case .success(let articles):
                        self?.news = articles
                        
                        
                        
                        DispatchQueue.main.async {
                            
                            self?.newsTableView.reloadData()
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        
        
    }


extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = newsTableView.dequeueReusableCell(withIdentifier:"NewsCell" , for: indexPath) as! NewsTableViewCell
        
        let currentNews = news[indexPath.row]
        
        cell.newsTitleLabel.text =  currentNews.title
        cell.newsDescriptionLabel.text = currentNews.description
        
        
        cell.newsTitleLabel.numberOfLines = 0
        cell.newsDescriptionLabel.numberOfLines = 0
        
        cell.newsTitleLabel.font  = .systemFont(ofSize: 25,weight: .semibold)
        cell.newsDescriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
        cell.newsImageView.layer.cornerRadius = 6
        cell.newsImageView.layer.masksToBounds = true
        cell.newsImageView.contentMode = .scaleAspectFill
        cell.newsImageView.backgroundColor = .secondarySystemBackground
        cell.newsImageView.clipsToBounds = true
        
        
        
        guard let imageUrl = URL(string: currentNews.urlToImage ?? "") else {
            return cell
        }
        
        cell.newsImageView.kf.setImage(with: imageUrl)
        
        return cell
    }
    
    func loadNewsStories() {
        
        APICaller.shared.getNewsStories{ [weak self]  result in
            switch result {
            case .success(let articles):
                self?.news = articles
                
                
                
                DispatchQueue.main.async {
                    
                    self?.newsTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180
    }
    
}
    
extension MainViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            
            loadNewsStories()
        } else {
            APICaller.shared.search(with: searchText) { [weak self] result in
                switch result {
                case .success(let articles):
                    self?.news = articles
                    DispatchQueue.main.async {
                        self?.newsTableView.reloadData()
                    }
                case .failure(let error):
                    print("Search error: \(error)")
                }
            }
        }
    }
}

