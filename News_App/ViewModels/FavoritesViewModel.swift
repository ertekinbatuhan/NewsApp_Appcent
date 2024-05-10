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
    
    var newsItemsArray = BehaviorSubject<[News]>(value: [News]())
    
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
                    
                    var favoriteNews = [News]()
                    
                    for document in snapshots!.documents {
                        if let newsTitle = document.get("title") as? String,
                           let newsUrl = document.get("url") as? String ,
                           let newsSource = document.get("source") as? String,
                           let newsAuthor = document.get("author") as? String,
                           let newsPuslihedDate = document.get("Date") as? String,
                           let newsDescription = document.get("description") as? String,
                           let newsImageUrl = document.get("urlToImage") as? String {
                            let newsItem = News(source: Source(name: newsSource), title: newsTitle, description: newsDescription, url: newsUrl, urlToImage: newsImageUrl,publishedAt: newsPuslihedDate, author: newsAuthor)
                        
                            favoriteNews.append(newsItem)
                        
                        }
                    }
                    
                    self.newsItemsArray.onNext(favoriteNews)
                }
            }
      }
    
    func removeNewsFromFavorites(_ newsIndex: News) {
        let db = Firestore.firestore()
        let newsCollection = db.collection("News")
        let newsTitle = newsIndex.title
        
 
        newsCollection.whereField("title", isEqualTo: newsTitle).getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("title not found")
                return
            }
            
            for document in documents {
                newsCollection.document(document.documentID).delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("delete is succesfull")
                    }
                }
            }
        }
    }
}
