//
//  ViewController.swift
//  Recipes Finder
//
//  Created by Nelson Gonzalez on 3/3/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ingredientsTextView: UITextView!
    
    @IBOutlet weak var websiteUrlLabel: UILabel!
    
    
    var recipesController: RecipesController?
    
    var recipes: Recipes? {
        didSet {
            updateViews()
        }
    }
    
    var url = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
        websiteUrlLabel.isUserInteractionEnabled = true
        websiteUrlLabel.addGestureRecognizer(tap)
    }
    
    // And that's the function :)
    @objc func onClicLabel(sender:UITapGestureRecognizer) {
        openUrl(urlString: url)
    }
    
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }


    private func updateViews() {
        guard isViewLoaded else {return}
        guard let recipes = recipes else {return}
        title = recipes.title
        titleLabel.text = recipes.title
        ingredientsTextView.text = recipes.ingredients
        
//        let string = "Visit Website To See Full Recipe"
//        let attributedString = NSMutableAttributedString(string: string, attributes:[NSAttributedString.Key.link: recipes.url])
        
     //   websiteUrlLabel.attributedText = attributedString
        
        url = recipes.url
        
        
      //  websiteUrlLabel.text = recipes.url
        
        guard let imageUrl = URL(string: recipes.thumbnail), let imageData = try? Data(contentsOf: imageUrl) else {
            imageView.image = #imageLiteral(resourceName: "food")
            return
            
        }
        
        imageView.image = UIImage(data: imageData)
        
    }

}

