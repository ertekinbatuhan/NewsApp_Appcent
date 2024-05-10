//
//  FavoritesViewModel.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 10.05.2024.
//

import Foundation
import RxSwift
import Firebase

class FavoritesViewModel {
    
    var newsItemsArray = BehaviorSubject<[FavoriteNews]>(value: [FavoriteNews]())
    
    init() {
        
        
        loadNews()
    }
    
    
    func loadNews() {
            
            let db = Firestore.firestore()
            
            db.collection("News").addSnapshotListener { snapshots, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    
                    // self.newsItems.removeAll()
                    
                    var favoriteNews = [FavoriteNews]()
                    
                    for document in snapshots!.documents {
                        if let newsTitle = document.get("title") as? String,
                           let newsUrl = document.get("url") as? String ,
                           let newsAuthor = document.get("author") as? String,
                           let newsPuslihedDate = document.get("Date") as? String,
                           let newsDescription = document.get("description") as? String,
                           let newsImageUrl = document.get("urlToImage") as? String {
                            let newsItem = FavoriteNews(title: newsTitle, urlToImage: newsImageUrl, url: newsUrl, description: newsDescription, author: newsAuthor, publishedDate: newsPuslihedDate)
                            
                            favoriteNews.append(newsItem)
                        
                        }
                    }
                    
                    self.newsItemsArray.onNext(favoriteNews)
                }
            }
        }
}
