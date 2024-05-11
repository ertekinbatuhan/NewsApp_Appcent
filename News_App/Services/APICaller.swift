//
//  APICaller.swift
//  NewsApp
//
//  Created by Batuhan Berk Ertekin on 26.02.2024.
//

import Foundation


final class APICaller {
    
    static let shared = APICaller()
    
    struct Constants {
        
        static let topHeadlinesURL = URL(string:"https://newsapi.org/v2/everything?q=us&apiKey=15699190f7eb48d7823cacf951f5f49f")
        
        static let searchUrlString = "https://newsapi.org/v2/everything?sortBy=us&apiKey=15699190f7eb48d7823cacf951f5f49f&q="
       
    }
    
    private init() {
        
    }
    
    public func requestData(completion: @escaping(Result<[News] , Error>) -> Void ) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self ,from: data)
                    
                    completion(.success(result.articles))
                    
                }catch {
                    completion(.failure(error))
                    
                }
            }
        }
        task.resume()
    }
    
    public func search(with query : String , completion: @escaping(Result<[News] , Error>) -> Void ) {
        
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
          
            return
        }
        
        let urlString = Constants.searchUrlString + query
        
        guard let url = URL(string : urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self ,from: data)
                
                    completion(.success(result.articles))
                    
                }catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
    
    
