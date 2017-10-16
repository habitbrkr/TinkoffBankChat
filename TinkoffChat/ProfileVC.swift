//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 20.09.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol GCDDelegate: class {
    func saveObjects(_ objects: [Any?], toFile: String) -> Bool
}

protocol OperationDelegate: class {
    func saveObjects(_ objects: [Any?], toFile: String) -> Bool
}

struct Profile {
    var name: String
    var info: String
    var image: UIImage?
    
    init(name: String, info: String, image: UIImage? = nil) {
        self.name = name
        self.info = info
        self.image = image
    }
}

class op: Operation {
    
}

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // MARK: Main funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        logFunctionName()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        newChanges = false
    }
    
    @objc func keyboardUp(notification: Notification) {
        show = 1.0
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.bounds.origin.y += (keyboardFrame.height - self.editProfileWithGCDButton.bounds.height * 3 )
        })
        
        /*
        if keyboardSize == nil {
            // TODO: Починить ебаный keyboardSize, чтобы блять не было в значении нуля.
            keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        }
        print(keyboardSize!)
        self.view.frame.origin.y = -keyboardSize!.height
        print(self.view.frame.origin.y)
        print("**********")*/
    }
    
    @objc func keyboardDown(notification: Notification) {
        show = -1.0
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.bounds.origin.y -= (keyboardFrame.height - self.editProfileWithGCDButton.bounds.height * 3 )
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if cornerRadius == 0 {
            cornerRadius = (changePhotoButton.bounds.size.width) / 2 // + 4
        }
        changePhotoButton.layer.cornerRadius = cornerRadius
        photoImageView.layer.cornerRadius = cornerRadius
    }
    func updateUI() {
        // TODO: Get_Data_from_file
        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Any?] {
            objects = array
            if let photo = objects[photo] as? UIImage?,
                let name = objects[name] as? String?,
                let info = objects[info] as? String? {
                photoImageView.image = photo
                nameTextField.text = name
                infoTextField.text = info
            }
        }

        photoImageView.clipsToBounds = true
        editProfileWithGCDButton.layer.borderWidth = 1.0
        editProfileWithGCDButton.layer.cornerRadius = 12.0
        editProfileWithOperationButton.layer.borderWidth = 1.0
        editProfileWithOperationButton.layer.cornerRadius = 12.0
    }
    func logFunctionName(method: String = #function) {
        print("Completed ProfileVC.\(lastMethod)\nStarted ProfileVC.\(method)")
        lastMethod = method
    }
    
    // MARK: Image funcs
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = image
            somethingChanged()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func insertNewObject(sender: Any?) {
        NSKeyedArchiver.archiveRootObject(objects, toFile: filePath)
    }
    
    // MARK: @TextField funcs
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: @IBActions
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func changePhotoAction(_ sender: Any) {
        print("changePhotoAction")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        let chooseActionSheet = UIAlertController(title: "Library or Camera?", message: "Choose a photo from Library or take new photo", preferredStyle: .actionSheet)
        chooseActionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Photo Library not available")
            }
        }))
        chooseActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        chooseActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(chooseActionSheet, animated: true, completion: nil)
    }
    @IBAction func somethingChanged() {
        if !newChanges {
            newChanges = true
            editProfileWithGCDButton.isEnabled = true
            editProfileWithOperationButton.isEnabled = true
        }
    }
    // TODO: Move View when keyboard show
    @IBAction func editProfileWithGCD(_ sender: Any?) {
        activityIndicator.startAnimating()
        let image = self.photoImageView.image as Any?
        let name = self.nameTextField.text as Any?
        let info = self.infoTextField.text as Any?
        let objects = [image, name, info] as [Any?]
        if instanceGCD.saveObjects(objects, toFile: filePath) {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            newChanges = false
            editProfileWithGCDButton.isEnabled = false
            editProfileWithOperationButton.isEnabled = false
            let alert = UIAlertController(title: "Данные сохранены", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.editProfileWithGCD(nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func editProfileWithOperation(_ sender: Any) {
        //instanceOperation.
        editProfileWithGCD(self)
    }
    
    // MARK: @IBOutlets
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var editProfileWithGCDButton: UIButton!
    @IBOutlet weak var editProfileWithOperationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Vars and Lets
    var objects = [Any?]()
    var newChanges = false
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        return (url.appendingPathComponent("objectFile")?.path)!
    }
    var lastMethod: String = "Opening VC"
    var instanceGCD = GCDDataManager()
    //var instanceOperation = OperationDataManager()
    var keyboardSize: CGRect? = nil
    var show: CGFloat = 1.0
    var cornerRadius: CGFloat = 0.0
    var activeTextField: UITextField!
    let isProfileImageLoaded = "isProfileImageLoaded"
    let isProfileNameLoaded = "isProfileNameLoaded"
    let isProfileInfoLoaded = "isProfileInfoLoaded"
    let profileNameKey = "profileName"
    let profileInfoKey = "profileInfo"
    let profileImageKey = "profileImage"
    let photo = 0, name = 1, info = 2
}


















