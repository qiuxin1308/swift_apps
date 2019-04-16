//
//  MeViewController.swift
//  ClassHero
// change icon profile password
//  Created by ouyang chenxing on 02/19/18.
//  Copyright © 2018 CSE437. All rights reserved.

import UIKit
import Firebase
import SVProgressHUD //processing indicator

class MeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource {

    var email: String?
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addTagsDropDown: UITextField!
    @IBOutlet weak var myTagsDropDown: UITextField!
    
    var list = ["","CSE104","CSE131","CSE222","CSE240","CSE247","CSE260","CSE311","CSE330","CSE332","CSE347","CSE361","CSE362","CSE416","CSE417","CSE422","CSE425","CSE427","CSE437","CSE438","CSE450","CSE465","CSE473","CSE501","CSE502","CSE504","CSE505","CSE511","CSE514","CSE523","CSE543","CSE547","CSE554","CSE556","CSE557","CSE559","CSE560","CSE574","CSE585","CSE587","CSE591"]
    var tagDropdownPicker = UIPickerView()
    var myTagDropdownPicker = UIPickerView()
    var tempList = [String: Bool]()
    var myTagsList = [String: Bool]()
    var score: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserInfo()
    }
    
    //the pickerView for the class tag
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows: Int = list.count
        if pickerView == myTagDropdownPicker {
            countRows = myTagsList.count
        }
        return countRows
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == tagDropdownPicker {
            return list[row]
        }else if pickerView == myTagDropdownPicker {
            let arrayList = Array(myTagsList.keys)
            return arrayList[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == tagDropdownPicker {
            addTagsDropDown.text = list[row]
            addTagsDropDown.resignFirstResponder()
        }else if pickerView == myTagDropdownPicker {
            let arrayList = Array(myTagsList.keys)
            myTagsDropDown.text = arrayList[row]
            myTagsDropDown.resignFirstResponder()
        }
    }
    
    //&&& CONFIRM TO CHANGE PROFILE &&&
    @IBAction func confirmPressed(_ sender: UIButton) {
        //processing indicator appear
        SVProgressHUD.show()
        let uid = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        let imageName = uid
        let storageRef = Storage.storage().reference().child("Avatar_Images").child("\(imageName).jpg")
        if let avatarImage = self.avatarImageView.image, let uploadData = UIImageJPEGRepresentation(avatarImage, 0.1){
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
            if error != nil {
                print(error!)
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yeah, I know, Close this", style: .default, handler: { (action) in }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if let avatarImageUrl = metadata?.downloadURL()?.absoluteString{
                
                Auth.auth().signIn(withEmail: self.email!, password: self.passwordTextField.text!) { (user, error) in
                    if error != nil {
                        print(error!)
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Yeah, I know, Close this", style: .default, handler: { (action) in }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    } else{ //Vefify User password, reset values in firebase
                        if self.addTagsDropDown.text == "" {
                            if self.myTagsDropDown.text == "" {
                                usersReference.setValue(["name": self.nameTextField.text!, "email": self.email!, "avatarURL": avatarImageUrl, "score": self.score!,"classTag": self.tempList])
                                ProgressHUD.showSuccess("Success")
//                                let failAlert = UIAlertController(title: "Fail to update", message: "Add Tag or change tag field cannot be empty.", preferredStyle: .alert)
//                                let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
//                                failAlert.addAction(cancelAction)
//                                self.present(failAlert, animated: true, completion: nil)
                            }else {
                                self.tempList.updateValue(false, forKey: self.myTagsDropDown.text!)
                                usersReference.setValue(["name": self.nameTextField.text!, "email": self.email!, "avatarURL": avatarImageUrl, "score": self.score!,"classTag": self.tempList])
                                ProgressHUD.showSuccess("Success")
                            }
                        } else {
                            if self.myTagsDropDown.text == "" {
                                if self.tempList[self.addTagsDropDown.text!] != nil {
                                    let failWindow = UIAlertController(title: "Fail to update", message: "You have alreay added the course tag.", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                                    failWindow.addAction(cancelAction)
                                    self.present(failWindow, animated: true, completion: nil)
                                }else{
                                    self.tempList.updateValue(true, forKey: self.addTagsDropDown.text!)
                                    usersReference.setValue(["name": self.nameTextField.text!, "email": self.email!, "avatarURL": avatarImageUrl, "score": self.score!,"classTag": self.tempList])
                                    ProgressHUD.showSuccess("Success")
                                }
                            } else {
                                if self.tempList[self.addTagsDropDown.text!] != nil {
                                    let failWindow = UIAlertController(title: "Fail to update", message: "You have alreay added the course tag.", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                                    failWindow.addAction(cancelAction)
                                    self.present(failWindow, animated: true, completion: nil)
                                }else{
                                    self.tempList.updateValue(true, forKey: self.addTagsDropDown.text!)
                                    self.tempList.updateValue(false, forKey: self.myTagsDropDown.text!)
                                    //print(self.tempList.keys)
                                    usersReference.setValue(["name": self.nameTextField.text!, "email": self.email!, "avatarURL": avatarImageUrl, "score": self.score!,"classTag": self.tempList])
                                    ProgressHUD.showSuccess("Success")
                                }
                            }
                        }
                        //usersReference.updateChildValues(["classTag": self.addTagsDropDown.text!])
                        SVProgressHUD.dismiss()
                    }
                }
            }
            })
        }
    }
    
    //$$$ LOGOUT $$$
    @IBAction func logoutPressed(_ sender: UIButton) {
        // Log out the user and send them back to WelcomeViewController
        do{
            try Auth.auth().signOut()
            ProgressHUD.showSuccess("Logout!")
            self.performSegue(withIdentifier: "unwindToViewController", sender: self)
        } catch {
            print("error, there was a problem signing out.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 8
        logoutButton.layer.cornerRadius = 8
        confirmButton.layer.masksToBounds = true
        logoutButton.layer.masksToBounds = true
        fetchUserInfo()
        self.passwordTextField.delegate = self
        self.nameTextField.delegate = self
        //list all my tags
        addTagsDropDown.inputView = tagDropdownPicker
        tagDropdownPicker.delegate = self
        tagDropdownPicker.dataSource = self
        addTagsDropDown.textAlignment = .center
        //list the tags with true value
        myTagsDropDown.inputView = myTagDropdownPicker
        myTagDropdownPicker.delegate = self
        myTagDropdownPicker.dataSource = self
        myTagsDropDown.textAlignment = .center
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func fetchUserInfo() {
        let uid = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid) // uid is primary key of a user
        usersReference.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let currentUser = Contact(dictionary: dictionary)
                //get inforamtion from dictionary
//                currentUser.name = dictionary["name"] as? String
//                currentUser.email = dictionary["email"] as? String
//                currentUser.avatarURL = dictionary["avatarURL"] as? String
                
                self.updateDisplay(currentUser: currentUser)
            }
        }
    }
    
    func updateDisplay(currentUser: Contact){
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectAvatar)))
        avatarImageView.isUserInteractionEnabled = true
        //avatarImageView.clipsToBounds = true
        avatarImageView.layer.masksToBounds = true
        
        if let avatarURL = currentUser.avatarURL {
            avatarImageView.loadImageUsingCacheWithURL(urlString: avatarURL)
        }else {
            avatarImageView.image = UIImage(named: "default-avatar")
        }
        email = currentUser.email!
        ratingLabel.text = "Your score: " + String(currentUser.score!)
        emailLabel.text = "E-mail: " + currentUser.email!
        nameTextField.text = currentUser.name!
        passwordTextField.text = ""
        addTagsDropDown.text = ""
        myTagsDropDown.text = ""
        myTagsList.removeAll()
        //noChangeList = currentUser.classTag!
        tempList = currentUser.classTag!
        score = currentUser.score!
        for key in tempList.keys {
            if tempList[key] == true {
                myTagsList.updateValue(tempList[key]!, forKey: key)
            }
        }
        //print(myTagsList.count)
    }
    
    //select image from photo library
    @objc func handleSelectAvatar(){
        print("$$$$$ avatar pressed  $$$$$")
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    //image picker controller (a new view controller pushed on the register view)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            avatarImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel image picker")
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
