//
//  SlideshowView.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 25/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit

class SlideshowView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    var imagesPrefix: String! {
        didSet {
            loadImages()
        }
    }
    
    private var imageNames = [String]()
    private var index = 0
    
    private func loadImages() {
        
        var i = 1
        var image: UIImage!
        
        while true {
            
            let name = "\(imagesPrefix!)-\(i)"
            image = UIImage(named: name)
            
            if image != nil {
                imageNames.append(name)
            } else {
                break
            }
            
            i += 1
        }
        
        if imageNames.isEmpty {
            fatalError("No image was found with prefix \(imagesPrefix!)")
        }
        
        index = -1
        nextImage()
    }
    
    func nextImage() {
        
        index = (index + 1) % imageNames.count
        imageView.image = UIImage(named: imageNames[index])
    }
}
