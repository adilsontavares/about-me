//
//  CardViewController.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 25/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit
import SwiftyJSON

class CardViewController: BaseViewController, CardDelegate, CountdownDelegate, TypingLabelDelegate {

    var typingLabelContainer: UIView!
    var typingLabel: TypingLabel!
    var card: Card!
    var countdown: Countdown!
    
    let cardMargin: CGFloat = 40
    var cardBottomConstraint: NSLayoutConstraint!
    
    var contentView: UIView? {
        return card.contentView
    }
    
    var wantsCountdown: Bool {
        return false
    }
    
    var contentNibName: String {
        fatalError("contentNibName is not defined on CardViewController subclass.")
    }
    
    var autoClickDuration: TimeInterval = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCard()
        card.loadContent(from: contentNibName)
        
        if wantsCountdown {
            createCountdown()
        }
        
        let texts = data["texts"].arrayObject as! [String]
        if !texts.isEmpty {
            createTypingLabel()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        card.transform = CGAffineTransform(translationX: 0, y: view.bounds.height * 2)
        card.transform = card.transform.scaledBy(x: 0.9, y: 0.9)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.transform = .identity
        }, completion: { _ in
            self.countdown?.start()
        })
        
        if typingLabel != nil {
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(showTextArea), userInfo: nil, repeats: false)
        }
    }
    
    private func createCountdown() {
        
        countdown = Countdown()
        countdown.delegate = self
        countdown.runsForever = true
        countdown.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(countdown)
        
        let size: CGFloat = 40
        countdown.widthAnchor.constraint(equalToConstant: size).isActive = true
        countdown.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        let offset: CGFloat = 30
        card.rightAnchor.constraint(equalTo: countdown.rightAnchor, constant: offset).isActive = true
        card.bottomAnchor.constraint(equalTo: countdown.bottomAnchor, constant: offset).isActive = true
    }
    
    private func createTypingLabel() {
        
        typingLabelContainer = UIView()
        typingLabelContainer.backgroundColor = .clear
        typingLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(typingLabelContainer)
        
        typingLabelContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: cardMargin).isActive = true
        view.rightAnchor.constraint(equalTo: typingLabelContainer.rightAnchor, constant: cardMargin).isActive = true
        typingLabelContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        typingLabelContainer.topAnchor.constraint(equalTo: card.bottomAnchor).isActive = true
        
        typingLabel = TypingLabel()
        typingLabel.delegate = self
        typingLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        typingLabel.targetTexts = data["texts"].arrayObject as! [String]
        typingLabel.translatesAutoresizingMaskIntoConstraints = false
        typingLabelContainer.addSubview(typingLabel)
        
        typingLabel.anchorCenterXToSuperview()
        typingLabel.anchorCenterYToSuperview()
        typingLabel.leftAnchor.constraint(equalTo: typingLabelContainer.leftAnchor).isActive = true
    }
    
    func typingLabelDidFinishTyping(_ label: TypingLabel) {
        hideTextArea()
    }
    
    func typingLabelDidCompleteText(_ label: TypingLabel) {
        
    }
    
    func typingLabelDidStartTypingText(_ label: TypingLabel) {
        
    }
    
    func nextController() {
        
        var transform = CGAffineTransform(translationX: 0, y: view.bounds.height * 2)
        transform = transform.scaledBy(x: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.card.transform = transform
        }, completion: { _ in
            StoryManager.main.nextViewController()
        })
    }
    
    @objc private func showTextArea() {
        toggleTextAreaAnimated(visible: true)
    }
    
    private func hideTextArea() {
        toggleTextAreaAnimated(visible: false)
    }
    
    private func toggleTextAreaAnimated(visible: Bool) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.cardBottomConstraint.constant = visible ? 150 : 40
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.typingLabel.startTyping()
        })
    }
    
    private func createCard() {
        
        card = Card()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.delegate = self
        view.addSubview(card)
        
        card.anchorCenterXToSuperview()
        card.widthAnchor.constraint(equalTo: card.heightAnchor, multiplier: 3 / 2, constant: 0).isActive = true
        
        let centerY = card.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerY.priority = .defaultLow
        centerY.isActive = true
        
        card.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: cardMargin).isActive = true
        let left = card.leftAnchor.constraint(equalTo: view.leftAnchor, constant: cardMargin)
        left.priority = .defaultHigh
        left.isActive = true
        
        view.rightAnchor.constraint(greaterThanOrEqualTo: card.rightAnchor, constant: cardMargin).isActive = true
        
        cardBottomConstraint = view.bottomAnchor.constraint(greaterThanOrEqualTo: card.bottomAnchor, constant: cardMargin)
        cardBottomConstraint.isActive = true
    }
    
    func countdownDidFinish(_ countdown: Countdown) {
        card.click()
    }
    
    func cardWasPressed(_ card: Card) {
        countdown?.restart()
    }
}
