//
//  BaseViewController.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 25/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit
import SwifterSwift
import SwiftyJSON

class BaseViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { return true }

    private var effectView: UIVisualEffectView!
    private var imageView: UIImageView!
    
    var backgroundImage: UIImage? {
        didSet {
            if imageView != nil {
                updateBackgroundImage(backgroundImage, animated: true)
            }
        }
    }
    var data: JSON!
    
    init(data: JSON) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0x34373d)
        
        createEffect()
        createImageView()
    }
    
    private func updateBackgroundImage(_ image: UIImage?, animated: Bool) {
        
        if !animated {
            imageView.image = image
            return
        }
        
        UIView.transition(with: self.imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.imageView.image = image
        }, completion: nil)
    }
    
    private func createEffect() {
        
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(view, at: 0)
        
        self.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        effectView = view
    }
    
    private func createImageView() {
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = backgroundImage
        view.insertSubview(imageView, at: 0)
        
        self.view.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        self.view.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        self.view.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    }
}
