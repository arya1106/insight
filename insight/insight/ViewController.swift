//
//  ViewController.swift
//  insight
//
//  Created by Sarthak Mangla on 1/20/23.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet var reportIncident: UIButton!
    @IBOutlet var exploreData: UIButton!
    let locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: CGFloat(27)/255.0, green: CGFloat(26)/255.0, blue: CGFloat(26)/255.0, alpha: 1)
        
//        reportIncident.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19.0);
//        reportIncident.titleLabel?.textColor = UIColor(red: CGFloat(57)/255.0, green: CGFloat(57)/255.0, blue: CGFloat(57)/255.0, alpha: 1)
        reportIncident.backgroundColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1)
        reportIncident.layer.cornerRadius = 10
        
//        exploreData.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19.0);
//        exploreData.titleLabel?.textColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1)
        exploreData.layer.borderColor = CGColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1)
        exploreData.layer.borderWidth = 2.0
        exploreData.layer.cornerRadius = 10
        
    }



}

