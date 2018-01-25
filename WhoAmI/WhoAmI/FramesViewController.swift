//
//  FramesViewController.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 25/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit
import SwiftyJSON

class FramesViewController: CardViewController {

    override var wantsCountdown: Bool { return false }
    override var contentNibName: String { return "Image" }
    
    private var imageIndex = -1
    private var imageNames = [String]()
    
    var imageView: UIImageView {
        return contentView as! UIImageView
    }
    
    override init(data: JSON) {
        
        let frames = data["frames"].arrayValue
        var texts = [String]()
        
        for frame in frames {
            texts.append(frame["text"].stringValue)
        }
        
        var newData = JSON(data)
        newData["texts"] = JSON(texts)
        super.init(data: newData)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func typingLabelDidStartTypingText(_ label: TypingLabel) {
        
        if label.targetTextIndex != 0 {
            
            nextImage()
            updateBackgroundImage()
        }
    }
    
    override func typingLabelDidFinishTyping(_ label: TypingLabel) {
        nextController()
    }
    
    private func nextImage() {
        
        imageIndex += 1
        
        let name = imageNames[imageIndex]
        let image = UIImage(named: name)
        
        UIView.transition(with: imageView, duration: 0.3, options:.transitionCrossDissolve, animations: {
            self.imageView.image = image
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frames = data["frames"].arrayValue
        for frame in frames {
            imageNames.append(frame["image"].stringValue)
        }
        
        nextImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBackgroundImage()
    }
    
    private func updateBackgroundImage() {
        backgroundImage = imageView.image
    }
}
