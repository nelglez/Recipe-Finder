//
//  FetchImageOperation.swift
//  Recipes Finder
//
//  Created by Nelson Gonzalez on 3/3/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import UIKit

class FetchImageOperation: ConcurrentOperation {

        let recipesReference: Recipes
        var imageData: Data?
        
        private var dataTask: URLSessionDataTask?
        
        init(recipesReference: Recipes) {
            self.recipesReference = recipesReference
            super.init()
        }
        
        
        override func start() {
            state = .isExecuting
            
            guard let imageUrl = URL(string: recipesReference.thumbnail) else {return}
            
            dataTask = URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, _, error) in
                
                
                defer { self.state = .isFinished }
                
                if self.isCancelled { return }
                
                if let error = error {
                    print("Error with data task: \(error)")
                }
                
                guard let data = data else {
                    print("Error getting data back")
                    return
                }
                
                self.imageData = data
                
            })
            
            dataTask?.resume()
        }
        
        
        override func cancel() {
            dataTask?.cancel()
            super.cancel()
        }
}
