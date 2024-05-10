//
//  NewsDetailsViewController.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 10.05.2024.
//

import UIKit
import Firebase

class NewsDetailsViewController: UIViewController {
    
    var selectedNews  : News?
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var newsDetailsViewModel = NewsDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = selectedNews?.title
        authorLabel.text = selectedNews?.author
        descriptionLabel.text = selectedNews?.description
        titleLabel.numberOfLines = 0
        authorLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        
        titleLabel.font  = .systemFont(ofSize: 25,weight: .semibold)
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
        let copyUrlIcon = UIImage(systemName:"square.and.arrow.up")
        let favoriteIcon = UIImage(systemName:"heart")
        
        let copyUrlItem = UIBarButtonItem(image: copyUrlIcon, style: .plain, target: self, action: #selector(copyUrlItemTapped))
        let favoriteItem = UIBarButtonItem(image : favoriteIcon, style: .plain, target: self, action: #selector(favoriItemTapped))
        
        navigationItem.rightBarButtonItems = [favoriteItem, copyUrlItem]
        
        newsImageView.layer.cornerRadius = 12
        newsImageView.layer.masksToBounds = true
        newsImageView.clipsToBounds = true
        newsImageView.contentMode = .scaleAspectFill
        
        let dateString = selectedNews?.publishedAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: dateString!) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = dateFormatter.string(from: date)
            dateLabel.text = formattedDate
        } else {
            dateLabel.text = "Invalid Date"
        }
        
        if let imageUrlString = selectedNews?.urlToImage, let imageUrl = URL(string: imageUrlString) {
            newsImageView.kf.setImage(with: imageUrl)
        } else {
            
            newsImageView.image = UIImage(named: "kingfisher")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let newsIndex = selectedNews {
                newsDetailsViewModel.checkIfNewsIsFavorite(newsIndex) { isFavorite in
                    
                    if isFavorite {
                        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
                    } else {
                        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
                    }
                }
            }
    }
    
    @objc func copyUrlItemTapped() {
        
        guard let newsUrlString = selectedNews?.url, let newsUrl = URL(string: newsUrlString) else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [newsUrl], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func newsSourceButton(_ sender: Any) {
        performSegue(withIdentifier: "newsSourceViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "newsSourceViewController",
           let newsSourceViewController = segue.destination as? NewsSourceViewController {
            
            newsSourceViewController.newsUrl = URL(string: selectedNews?.url ?? "")
        }
    }
    
    @objc func favoriItemTapped() {
        if let newsIndex = selectedNews {
            newsDetailsViewModel.checkIfNewsIsFavorite(newsIndex) { isFavorite in
                if isFavorite {
                    
                    self.newsDetailsViewModel.removeNewsFromFavorites(newsIndex)
                    self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
                } else {
                    
                    self.newsDetailsViewModel.addNewsToFavorites(newsIndex)
                    self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
                }
            }
        }
    }
}


