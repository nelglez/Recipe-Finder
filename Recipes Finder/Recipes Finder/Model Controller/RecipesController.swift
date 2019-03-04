//
//  RecipesController.swift
//  Recipes Finder
//
//  Created by Nelson Gonzalez on 3/3/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation

class RecipesController {
    
    private(set) var recipes: [Recipes] = []
    
    func fetchUsers(query: String, completion: @escaping(Error?)-> Void) {
        
//        let baseUrl = URL(string: "http://www.recipepuppy.com/api/?q\(query)")!
//        print(baseUrl)
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "recipepuppy.com"
        components.path = "/api/"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
         //   URLQueryItem(name: "sort", value: sorting.rawValue)
        ]
        
        // Getting a URL from our components is as simple as
        // accessing the 'url' property.
        let url = components.url!
        
        print("URL:", url)
        
      //  let request = URLRequest(url: newUrl)
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error with dataTask: \(error)")
                completion(error)
            }
            
            guard let data = data else {
                print("No data returned from the data task")
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let recipesDecoded = try decoder.decode(RecipeResults.self, from: data)
                self.recipes = recipesDecoded.results
                completion(nil)
            } catch {
                self.recipes = []
                print("Error decoding and getting data: \(error)")
                completion(error)
            }
            }.resume()
    }
}
