//
//  Card.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 24/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit

protocol CardDelegate {
    
    func cardWasPressed(_ card: Card)
}

class Card: UIView {
    
    var delegate: CardDelegate?
    var contentView: UIView?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 300))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        clipsToBounds = true
        
        layer.cornerRadius = 27
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 24
        layer.shadowOpacity = 0.6
        
        setupBackground()
    }
    
    func loadContent(from nibName: String) {
        
        if contentView != nil {
            print("Content view is already loaded. Cannot load another one.")
        }
        
        let nib = UINib(nibName: nibName, bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil) as! [UIView]
        let view = views.first!
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = layer.cornerRadius
        
        contentView = view
    }
    
    func click() {
        
        let scale: CGFloat = 0.9
        
        layer.removeAnimation(forKey: "click")
        
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.keyTimes = [0, 0.25, 1]
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.duration = 0.36
        anim.values = [
            CATransform3DIdentity,
            CATransform3DMakeScale(scale, scale, scale),
            CATransform3DIdentity
        ]
        
        layer.add(anim, forKey: "click")
        
        delegate?.cardWasPressed(self)
    }
    
    private func setupBackground() {
        
        for view in subviews {
            if view.bounds == self.bounds {
                view.layer.cornerRadius = layer.cornerRadius
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        click()
    }
}
