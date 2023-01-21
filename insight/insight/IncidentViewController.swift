//
//  IncidentViewController.swift
//  insight
//
//  Created by Sarthak Mangla on 1/21/23.
//

import UIKit
import CoreLocation


class IncidentViewController: UIViewController {

    @IBOutlet var submitReport: UIButton!
    @IBOutlet var locationLabel: UILabel!
    
    let locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var currentLocation: CLLocation!

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            currentLocation = locationManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                if let error = error {
                    print(error)
                } else if let placemarks = placemarks {
                    for placemark in placemarks {
                        self.locationLabel.text = "📍 " + String(placemark.locality!) + ", " + String(placemark.administrativeArea!)
                    }
                }
            }
        }

        
        view.backgroundColor = UIColor(red: CGFloat(27)/255.0, green: CGFloat(26)/255.0, blue: CGFloat(26)/255.0, alpha: 1)
        
        // Do any additional setup after loading the view.
        submitReport.backgroundColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1)
        submitReport.layer.cornerRadius = 10

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getAddress(fromLocation location: CLLocation) {
        

    }

}
