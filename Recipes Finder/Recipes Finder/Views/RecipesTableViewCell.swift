//
//  RecipesTableViewCell.swift
//  Recipes Finder
//
//  Created by Nelson Gonzalez on 3/3/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    var recipes: Recipes? {
        didSet {
            updateViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func updateViews() {
        guard let recipes = recipes else {return}
        recipeTitleLabel.text = recipes.title
//        guard let imageUrl = URL(string: recipes.thumbnail), let imageData = try? Data(contentsOf: imageUrl) else {
//            recipeImageView.image = UIImage(named: "food")
//            return
//            
//        }
//        
//        recipeImageView.image = UIImage(data: imageData)
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
        recipeImageView.image = UIImage(named: "food")
        recipeTitleLabel.text = "Loading"
    }

}
