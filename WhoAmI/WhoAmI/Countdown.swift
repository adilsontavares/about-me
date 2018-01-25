//
//  Timer.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 24/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit

protocol CountdownDelegate {
    
    func countdownDidFinish(_ countdown: Countdown)
}

class Countdown: UIView {

    var percent: CGFloat = 1
    var color: UIColor = .white
    
    var delegate: CountdownDelegate?
    
    private var timestamp: TimeInterval?
    
    var duration: TimeInterval = 5
    var running = false
    var runsForever = false
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        let displayLink = CADisplayLink(target: self, selector: #selector(update(displayLink:)))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    @objc private func update(displayLink: CADisplayLink) {
        
        if !running {
            return
        }
        
        if timestamp == nil {
            timestamp = displayLink.timestamp
            return
        }
        
        let deltaTime = displayLink.timestamp - timestamp!
        let deltaPercent = deltaTime / duration
        
        percent -= CGFloat(deltaPercent)
        timestamp = displayLink.timestamp
        
        if percent <= 0 {
            finish()
        }
        
        setNeedsDisplay()
    }
    
    func start() {
    
        stop()
        running = true
    }
    
    func resume() {
        running = true
    }
    
    func pause() {
        running = false
    }
    
    private func finish() {
        
        percent = 0
        running = false
        
        delegate?.countdownDidFinish(self)
        
        if runsForever {
            restart()
        }
    }
    
    func restart() {
        
        stop()
        start()
    }
    
    func stop() {
        
        percent = 1
        timestamp = nil
        running = false
    }
    
    override func draw(_ rect: CGRect) {
        
        let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        let context = UIGraphicsGetCurrentContext()!
        let radius = min(bounds.width, bounds.height) * 0.5
        let angle = percent * 2 * .pi
        let angleOffset = CGFloat.pi * 1.5
        
        context.saveGState()
        
        context.move(to: center)
        context.addArc(center: center, radius: radius, startAngle: angleOffset, endAngle: angleOffset - angle, clockwise: false)
        context.setFillColor(color.cgColor)
        context.fillPath()
        
        context.saveGState()
    }
}
