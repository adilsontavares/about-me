//
//  LocationViewController.swift
//  WhoAmI
//
//  Created by Adilson Tavares on 24/01/2018.
//  Copyright © 2018 Adilson Tavares. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }
    
    @IBOutlet weak var mapView: MKMapView!
    
    let coord = CLLocationCoordinate2DMake(-25.593875, -49.3958417)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let delta = 0.01
        let span = MKCoordinateSpanMake(delta, delta)
        
        let region = MKCoordinateRegion(center: coord, span: span)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(insertPin), userInfo: nil, repeats: false)
    }
    
    @objc private func insertPin() {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = "Minha casa"
        mapView.addAnnotation(annotation)
    }
}
