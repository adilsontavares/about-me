//
//  TalkingViewController.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 25/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit
import SwiftyJSON

class TalkingViewController: BaseViewController, TypingLabelDelegate {

    var label: TypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backgroundImage = nil
        label.startTyping()
    }
    
    func typingLabelDidFinishTyping(_ label: TypingLabel) {
        StoryManager.main.nextViewController()
    }
    
    func typingLabelDidCompleteText(_ label: TypingLabel) {
        
    }
    
    func typingLabelDidStartTypingText(_ label: TypingLabel) {
        
    }
    
    private func createLabel() {
        
        label = TypingLabel()
        label.delegate = self
        label.targetTexts = data["texts"].arrayObject as! [String]
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let margin: CGFloat = 40
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin).isActive = true
        
        view.centerXAnchor.constraint(equalTo: label.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
    }
}
