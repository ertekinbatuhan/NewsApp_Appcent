//
//  APICaller.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 8.05.2024.
//

import Foundation
import UIKit

final class APICaller {
    
    static let shared = APICaller()
    
    
    struct Constants  {
        
        static let newsURL = URL(string:"https://newsapi.org/v2/everything?q=us&apiKey=15699190f7eb48d7823cacf951f5f49f")
        
    }
    
    
    private init () {}
    
    public func getNewsStories(completion: @escaping(Result<[News] , Error>) -> Void ) {
           guard let url = Constants.newsURL else {
               return
           }
           
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   completion(.failure(error))
               }else if let data = data {
                   
                   do {
                       let result = try JSONDecoder().decode(APIResponse.self ,from: data)
                       
                       print("size : \(result.articles.count)")
                       
                       completion(.success(result.articles))
                       
                   }catch {
                       completion(.failure(error))
                       
                   }
               }
           }
           task.resume()
       }
}

