//
//  RecipesTableViewController.swift
//  Recipes Finder
//
//  Created by Nelson Gonzalez on 3/3/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cache = Cache<String, Data>()
    var imageFetchQueue = OperationQueue()
    var imageFetchOperations: [URL: FetchImageOperation] = [:]
    
    
    let recipesController = RecipesController()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
      
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        
    
        recipesController.fetchUsers(query: searchTerm.lowercased(), completion: { error  in
            
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                self.searchBar.endEditing(true)
                self.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipesController.recipes.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipesCell", for: indexPath) as! RecipesTableViewCell

        let recipes = recipesController.recipes[indexPath.row]
        cell.recipes = recipes
        fetchUserImages(for: cell, at: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let recipesPhotoImage = recipesController.recipes[indexPath.row]
        let url = URL(string: "https://picsum.photos/200/300")!
        if let photoImageFetchOperation = imageFetchOperations[URL(string: recipesPhotoImage.thumbnail) ?? url] {
            photoImageFetchOperation.cancel()
        }
    }
    

    func fetchUserImages(for cell: RecipesTableViewCell, at indexPath: IndexPath) {
        
        let recipesPhotoReference = recipesController.recipes[indexPath.row]
        
        let photoFetchOperation = FetchImageOperation(recipesReference: recipesPhotoReference)
        
        if let imageData = cache.value(for: recipesPhotoReference.title) {
            let image = UIImage(data: imageData)
            cell.recipeImageView.image = image
          //  return
        } else {
        
        
        let cachePhotoOperation = BlockOperation {
            //put it in a guard cause it was crashing when it was nil
            guard let photoFetchOperationImageData = photoFetchOperation.imageData else {return}
            self.cache.cache(value: photoFetchOperationImageData, for: recipesPhotoReference.title)
        }
        
        let updateUIImageCellOperation = BlockOperation {
            if let imageData = photoFetchOperation.imageData {
                let image = UIImage(data: imageData)
                cell.recipeImageView.image = image
            }
        }
        
        
        cachePhotoOperation.addDependency(photoFetchOperation)
        updateUIImageCellOperation.addDependency(photoFetchOperation)
        
        imageFetchQueue.addOperations([photoFetchOperation, cachePhotoOperation], waitUntilFinished: false)
        
        OperationQueue.main.addOperation(updateUIImageCellOperation)
        
      //  guard let imageUrl = recipesPhotoReference.thumbnail else {return}
        let url = URL(string: "https://picsum.photos/200/300")!
        
        imageFetchOperations[URL(string: recipesPhotoReference.thumbnail) ?? url] = photoFetchOperation
        }
    }

    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let destinationVC = segue.destination as? DetailViewController
        destinationVC?.recipesController = recipesController
        
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        
        let recipes = recipesController.recipes[indexPath.row]
        
        destinationVC?.recipes = recipes
    }
  
    
    

}
