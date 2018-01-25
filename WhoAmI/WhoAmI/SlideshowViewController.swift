//
//  SlideshowViewController.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 25/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit
import SwiftyJSON

class SlideshowViewController: CardViewController {

    override var wantsCountdown: Bool { return true }
    override var contentNibName: String { return "Slideshow" }
    
    var slideshowView: SlideshowView {
        return contentView as! SlideshowView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideshowView.imagesPrefix = data["images-prefix"].stringValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateBackground()
    }
    
    override func cardWasPressed(_ card: Card) {
        super.cardWasPressed(card)
        
        slideshowView.nextImage()
        updateBackground()
    }
    
    private func updateBackground() {
        backgroundImage = slideshowView.imageView.image
    }
}
