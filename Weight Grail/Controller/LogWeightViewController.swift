//
//  LogScreenViewController.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/21/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class LogWeightViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    var selectedWeight: Int!
    
    let pickerData = Array(1...600)
    let defaultWeight = 200
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weightPicker: UIPickerView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var uploadedImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightPicker.delegate = self
        weightPicker.dataSource = self
        configureDatabaseRef()
        configureStorageRef()
        navigationItem.title = "Log Weight"
        selectedWeight = defaultWeight
    }
    
    @IBAction func uploadImage(){
        let photoPickerController = UIImagePickerController()
        photoPickerController.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            photoPickerController.sourceType = .camera
        } else {
            photoPickerController.sourceType = .photoLibrary
        }
        present(photoPickerController, animated: true, completion: nil)
    }
    
    @IBAction func logDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let dateString = formatter.string(from: datePicker.date)
        let basePath = "users/\(Auth.auth().currentUser!.uid)/weight-log/\(dateString)"
        databaseRef.child("\(basePath)/weight").setValue(selectedWeight)
        if let newImage = uploadedImage.image {
            let data = newImage.jpegData(compressionQuality: 0.8)!
            let newMetadata = StorageMetadata()
            newMetadata.contentType = "image/jpeg";
            _ = storageRef.child("\(basePath)/image.jpg").putData(data, metadata: newMetadata) {(metadata, error) in
                guard let metadata = metadata else {return}
                
                self.databaseRef.child("\(basePath)/imagePath").setValue(metadata.path)
            }
        }
    }
    
    func configureStorageRef() {
        // gets the storage host
        storageRef = Storage.storage().reference()
    }
    
    func configureDatabaseRef() {
        databaseRef = Database.database().reference()
    }

}

extension LogWeightViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row]) lbs"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWeight = pickerData[row]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            uploadedImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
