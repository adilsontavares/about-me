//
//  StoryManager.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 25/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoryManager: NSObject {

    private var contextIndex = 0
    private var contexts: [JSON]!
    
    static var _main: StoryManager!
    class var main: StoryManager {
        if _main == nil {
            _main = StoryManager()
        }
        return _main!
    }
    
    override init() {
        super.init()
        
    }
    
    func load() {
        
        let url = Bundle.main.url(forResource: "Story", withExtension: "json")!
        let contents = try! NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
        let data = JSON(parseJSON: contents as String)
        
        contextIndex = -1
        contexts = data.arrayValue
        
        nextViewController()
    }
    
    func nextViewController() {
        
        contextIndex += 1
        if contextIndex >= contexts.count {
            return
        }
        
        loadViewController(withData: contexts[contextIndex])
    }
    
    private func loadViewController(withData data: JSON) {
     
        let context = data["context"].stringValue
        let controller: BaseViewController!
        
        switch context {
        case "story": controller = FramesViewController(data: data)
        case "talking": controller = TalkingViewController(data: data)
        case "slideshow": controller = SlideshowViewController(data: data)
        default: controller = nil
        }
        
        if controller == nil {
            fatalError("No controller was found for context \(context)")
        }
        
        makeControllerRoot(controller)
    }
    
    private func makeControllerRoot(_ newController: BaseViewController) {
        
        let window = UIApplication.shared.keyWindow!
        
        if let currentController = window.rootViewController as? BaseViewController {
        
            let backgroundImage = currentController.backgroundImage
            newController.backgroundImage = backgroundImage
        }
        
        window.rootViewController = newController
    }
}
