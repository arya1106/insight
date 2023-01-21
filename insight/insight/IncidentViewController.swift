//
//  IncidentViewController.swift
//  insight
//
//  Created by Sarthak Mangla on 1/21/23.
//

import UIKit
import CoreLocation


class IncidentViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

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
    
    @IBAction func addImage(_ sender: UIButton) {
        let ac = UIAlertController(title: "Add image", message: "Please attach an image that depicts the road damage properly", preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Take photo", style: .default) {[weak self] (_) in
            self?.showImagePicker(selectedSource: .camera)
        }
        let libraryButton = UIAlertAction(title: "Choose from library", style: .default) {[weak self] (_) in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(cameraButton)
        ac.addAction(libraryButton)
        ac.addAction(cancelButton)
        self.present(ac, animated: true, completion: nil)
    }
    
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            print("source not available asdkjfadsf")
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selectedImageView.image = selectedImage
            noImageLabel.isHidden = true
        } else {
            print("grrr no image")
        }
        picker.dismiss(animated: true, completion: nil)
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
