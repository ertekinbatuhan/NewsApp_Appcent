//
//  NewsDetailsViewModel.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 10.05.2024.
//

import Foundation
import UIKit
import Firebase

class NewsDetailsViewModel {
    
    func addNewsToFavorites(_ newsIndex: News) {
        
        let db = Firestore.firestore()
        
        let fireStoreNewsData  = ["source" : newsIndex.source.name ,"title": newsIndex.title, "description": newsIndex.description!, "url": newsIndex.url!, "urlToImage": newsIndex.urlToImage ?? "", "Date" : newsIndex.publishedAt , "author" : newsIndex.author ?? ""] as [String : Any]
        
        db.collection("News").addDocument(data: fireStoreNewsData , completion: { error in
            
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
            }
        })
    }
    
    func checkIfNewsIsFavorite(_ news: News, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let newsCollection = db.collection("News")
        let newsTitle = news.title
        
        newsCollection.whereField("title", isEqualTo: newsTitle).getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            if let documents = querySnapshot?.documents {
                
                let isFavorite = !documents.isEmpty
                completion(isFavorite)
            } else {
                
                completion(false)
            }
        }
    }
    
    func removeNewsFromFavorites(_ newsIndex: News) {
        let db = Firestore.firestore()
        let newsCollection = db.collection("News")
        let newsTitle = newsIndex.title
        
        newsCollection.whereField("title", isEqualTo: newsTitle).getDocuments { (querySnapshot, error) in
            if let error = error {
                print((error.localizedDescription))
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
                        print("title not found")
                    }
                }
            }
        }
    }
}
