//
//  ViewController.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 8.05.2024.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa


class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var newsSearchBar: UISearchBar!
    private var news = [News]()
    let disposeBag = DisposeBag()
    let newsViewModel = NewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
           backButton.title = "Back"
           navigationItem.backBarButtonItem = backButton
        
        newsSearchBar.delegate = self 
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsSearchBar.placeholder = "Search"
        newsSearchBar.backgroundImage = UIImage()
        setupBindings()
        newsViewModel.requestData()
        
            }
    
    
    private func setupBindings(){
        
        newsViewModel.error.observe(on: MainScheduler.asyncInstance).subscribe { error in
            print(error)
        }.disposed(by: disposeBag)
        
        newsViewModel.news.observe(on: MainScheduler.asyncInstance).subscribe{news in
            
            self.news = news
            self.newsTableView.reloadData()
        }.disposed(by: disposeBag)
    }
        
    }


extension NewsViewController : UITableViewDelegate, UITableViewDataSource {
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = news[indexPath.row]
        performSegue(withIdentifier: "toNewsDetails", sender: selectedNews)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewsDetails" {
            if let selectedNews = sender as? News, let destinationVC = segue.destination as? NewsDetailsViewController {
                destinationVC.selectedNews = selectedNews
            }
        }
    }
    
}

extension NewsViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            
            newsViewModel.requestData()
            newsTableView.reloadData()
            
        } else {
            
            newsViewModel.searchNews(searchText: searchText)
            newsTableView.reloadData()
        }
    }
}

