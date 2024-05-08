//
//  APICaller.swift
//  News_App
//
//  Created by Batuhan Berk Ertekin on 8.05.2024.
//

import Foundation
import UIKit



struct APICaller : Codable {
    let articles : [News]
    
}

struct News : Codable{
    
    let source : Source
    let title : String
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String
    
    
}

struct  Source : Codable {
    let name : String
    
}
