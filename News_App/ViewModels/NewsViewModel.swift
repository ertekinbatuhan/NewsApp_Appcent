//
//  NewsViewModel.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 10.05.2024.
//

import Foundation
import RxSwift
import RxCocoa

class NewsViewModel {
    
    let  news : PublishSubject<[News]> = PublishSubject()
    let error : PublishSubject<[String]> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject()
    
    func requestData() {
        self.loading.onNext(true)
        
        APICaller.shared.getNewsStories{ [weak self]  result in
            self?.loading.onNext(false)
                    switch result {
                    case .success(let articles):
                        self?.news.onNext(articles)
                
                    case .failure(let error):
                        print(error)
                    }
                }
    }
    
    func searchNews(searchText : String) {
        
        
        APICaller.shared.search(with: searchText) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.news.onNext(articles)
                
            case .failure(let error):
                print("Search error: \(error)")
            }
        }
    }
}

