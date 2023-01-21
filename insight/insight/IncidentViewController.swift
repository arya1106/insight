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
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var selectedImageView: UIImageView!
    @IBOutlet var noImageLabel: UILabel!
    @IBOutlet var crackType: UIButton!
    
    @IBAction func toggleCrackType(_ sender: UIButton) {
        let textValue: String = (crackType.titleLabel?.text)!
        if textValue == "horizontal crack" {
            crackType.layer.borderColor = CGColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1)
            crackType.layer.borderWidth = 2.0
            crackType.layer.cornerRadius = 10
            crackType.backgroundColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1)
            crackType.setTitleColor(UIColor(red: CGFloat(27)/255.0, green: CGFloat(26)/255.0, blue: CGFloat(26)/255.0, alpha: 1), for: .normal)
            crackType.setTitle("vertical crack", for: .normal)
        } else {
            crackType.layer.borderColor = CGColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1)
            crackType.layer.borderWidth = 2.0
            crackType.layer.cornerRadius = 10
            crackType.backgroundColor = UIColor(red: CGFloat(27)/255.0, green: CGFloat(26)/255.0, blue: CGFloat(26)/255.0, alpha: 1)
            crackType.setTitleColor(UIColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1), for: .normal)
            crackType.setTitle("horizontal crack", for: .normal)
        }
    }
    
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
        

        submitReport.backgroundColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1)
        submitReport.layer.cornerRadius = 10
        
        addImageButton.layer.borderColor = CGColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1)
        addImageButton.layer.borderWidth = 2.0
        addImageButton.layer.cornerRadius = 10
        
        selectedImageView.backgroundColor = UIColor(red: CGFloat(57)/255.0, green: CGFloat(57)/255.0, blue: CGFloat(57)/255.0, alpha: 1)
        
        noImageLabel.layer.zPosition = 1;
        
        crackType.layer.borderColor = CGColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1)
        crackType.layer.borderWidth = 2.0
        crackType.layer.cornerRadius = 10
        crackType.setTitleColor(UIColor(red: CGFloat(255)/255.0, green: CGFloat(189)/255.0, blue: CGFloat(90)/255.0, alpha: 1), for: .normal)
        crackType.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        crackType.setTitle("horizontal crack", for: .normal)
        
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
