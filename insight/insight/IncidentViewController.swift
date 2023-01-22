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
            selectedImageView.backgroundColor = UIColor.clear
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
    
    @IBAction func submitReport(_ sender: UIButton) {
        if selectedImageView.image == nil {
            var dialogMessage = UIAlertController(title: "No image attached", message: "Please attach an image!", preferredStyle: .alert)


            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("pressed ok")
            })
            
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        } else {
            let url = URL(string: "http://138.197.104.208:5000/report")
            let boundary: String = "Boundary-\(UUID().uuidString)"
            guard let requestUrl = url else { fatalError() }
            
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            
            request.setValue("\((locationManager.location?.coordinate.latitude)!)", forHTTPHeaderField: "latitude")
            request.setValue("\((locationManager.location?.coordinate.longitude)!)", forHTTPHeaderField: "longitude")
            request.setValue("\((crackType.titleLabel?.text)!)", forHTTPHeaderField: "cracktype")
            request.httpMethod = "POST"
            request.httpBody = multipartFormDataBody(boundary, "sarhtak", selectedImageView.image!)
            request.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    
                }
            }
            task.resume()
            var dialogMessage = UIAlertController(title: "Damage Recorded", message: "Your damage report has been recorded!", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    private func multipartFormDataBody(_ boundary: String, _ fromName: String, _ image: UIImage) -> Data {
            
        let lineBreak = "\r\n"
        var body = Data()
            
        body.append(Data("--\(boundary + lineBreak)".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"fromName\"\(lineBreak + lineBreak)".utf8))
        body.append(Data("\(fromName + lineBreak)".utf8))
        
        if let uuid = UUID().uuidString.components(separatedBy: "-").first {
            body.append(Data("--\(boundary + lineBreak)".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"imageUploads\"; filename=\"\(uuid).jpg\"\(lineBreak)".utf8))
            body.append(Data("Content-Type: image/jpeg\(lineBreak + lineBreak)".utf8))
            body.append(image.jpegData(compressionQuality: 0.99)!)
            body.append(Data(lineBreak.utf8))
        }
        
        body.append(Data("--\(boundary)--\(lineBreak)".utf8))
        return body
    }
    
        
}
