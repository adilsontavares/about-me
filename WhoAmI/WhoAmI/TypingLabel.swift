//
//  TypingLabel.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 24/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit

protocol TypingLabelDelegate {
    
    func typingLabelDidFinishTyping(_ label: TypingLabel)
    
    func typingLabelDidStartTypingText(_ label: TypingLabel)
    func typingLabelDidCompleteText(_ label: TypingLabel)
}

class TypingLabel: UILabel {

    private(set) var targetTextIndex = 0
    var targetTexts = [String]()
    
    var targetText: String! {
        if targetTextIndex >= targetTexts.count {
            return nil
        }
        return targetTexts[targetTextIndex]
    }
    
    var delegate: TypingLabelDelegate?
    
    let characterDuration: TimeInterval = 0.034
    let commaDuration: TimeInterval = 0.6
    let dotDuration: TimeInterval = 1.5
    
    let textDisappearDuration: TimeInterval = 0.8
    
    let minTextDuration: TimeInterval = 2
    let textDuration: TimeInterval = 0.1
    let maxTextDuration: TimeInterval = 5
    
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        textColor = .white
        numberOfLines = 0
        
        if targetTexts.isEmpty && text != nil {
            targetTexts = [text!]
        }
        
        text = ""
    }
    
    func startTyping() {
        nextChar()
    }
    
    private func textDidFinish() {
        
        var duration = textDuration * TimeInterval(targetText!.count)
        duration = min(max(duration, minTextDuration), maxTextDuration)
        
        delegate?.typingLabelDidCompleteText(self)
        
        Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(nextText), userInfo: nil, repeats: false)
    }
    
    @objc private func nextText() {
        
        targetTextIndex += 1
        
        UIView.transition(with: self, duration: textDisappearDuration, options:.transitionCrossDissolve, animations: {
            self.text = ""
        }, completion: { _ in
            self.nextChar()
        })
    }
    
    @objc private func nextChar() {
        
        if targetText == nil {
            delegate?.typingLabelDidFinishTyping(self)
            return
        }
        
        if text!.count >= targetText!.count {
            textDidFinish()
            return
        }
        
        if text!.isEmpty {
            delegate?.typingLabelDidStartTypingText(self)
        }
        
        let index = targetText.index(targetText.startIndex, offsetBy: text!.count)
        let char = targetText[index]
        
        UIView.transition(with: self, duration: characterDuration - 0.01, options:.transitionCrossDissolve, animations: {
            self.text!.append(char)
        }, completion: nil)
        
        let duration: TimeInterval
        switch char {
        case ",":   duration = commaDuration
        case ".":   duration = dotDuration
        default:    duration = characterDuration
        }
        
        Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(nextChar), userInfo: nil, repeats: false)
    }
}
