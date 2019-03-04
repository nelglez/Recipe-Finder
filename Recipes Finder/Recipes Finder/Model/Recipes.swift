//
//  Recipes.swift
//  Recipes Finder
//
//  Created by Nelson Gonzalez on 3/3/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation

struct RecipeResults: Decodable {
    var results: [Recipes]
}

struct Recipes: Decodable {
    let title: String
    let url: String
    let ingredients: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case url = "href"
        case ingredients
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        //create a cotainer
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let url = try container.decode(String.self, forKey: .url)
        let ingredients = try container.decode(String.self, forKey: .ingredients)
        let thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        
        self.title = title
        self.url = url
        self.ingredients = ingredients
        self.thumbnail = thumbnail!
    }
    
}
