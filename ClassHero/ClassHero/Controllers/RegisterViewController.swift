//
//  RegisterViewController.swift
//  ClassHero
//
//  Created by ouyang chenxing on 02/19/18.
//  Copyright © 2018 CSE437. All rights reserved.
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD //processing indicator

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    //Pre-linked IBOutlets
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet weak var Avatar: UIImageView!  //user Avatar
    @IBOutlet weak var classTextfield: UITextField!
    
    let tempScore = 0
    
    //create the list of the dropdown menu
    var list = ["","CSE104","CSE131","CSE222","CSE240","CSE247","CSE260","CSE311","CSE330","CSE332","CSE347","CSE361","CSE362","CSE416","CSE417","CSE422","CSE425","CSE427","CSE437","CSE438","CSE450","CSE465","CSE473","CSE501","CSE502","CSE504","CSE505","CSE511","CSE514","CSE523","CSE543","CSE547","CSE554","CSE556","CSE557","CSE559","CSE560","CSE574","CSE585","CSE587","CSE591"]
    var dropdownPicker = UIPickerView()
    var classTagValue = [String: Bool]()
    
    // the pickerView
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        classTextfield.text = list[row]
        classTextfield.resignFirstResponder()
    }
    
   
    @IBAction func goHome(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //choose Avatar from user Photos for register (UIButton)
    @IBAction func chooserAvatar(_ sender: UIButton) {
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
            Avatar.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel image picker")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processAvatar()
        classTextfield.inputView = dropdownPicker
        dropdownPicker.delegate = self
        dropdownPicker.dataSource = self
        classTextfield.textAlignment = .center
        classTextfield.text = list[0]
        emailTextfield.delegate = self
        nameTextfield.delegate = self
        passwordTextfield.delegate = self
        //self.present(dropdownPicker, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    //process for avatar
    func processAvatar(){
        Avatar.contentMode = .scaleAspectFill
        Avatar.layer.masksToBounds = true
        Avatar.layer.cornerRadius = Avatar.frame.width/2
        Avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectAvatar)))
        Avatar.isUserInteractionEnabled = true
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
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        //processing indicator appear
        SVProgressHUD.show()
        
        //create User and write User inforamtion into database
        Auth.auth().createUser(withEmail: self.emailTextfield.text!, password: passwordTextfield.text!, completion: { (user: User?, error) in
            if error != nil {  // handle error information
                print(error!)
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yeah, I know, Close this", style: .default, handler: { (action) in }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                //*********   REGISTER SUCCESS  ********
                print("Registration Successful!")
                
                //processor indicator disappear
                SVProgressHUD.dismiss()
                ProgressHUD.showSuccess("Register Success!")
                guard let uid = user?.uid else {
                    return
                }
                //$$$$   successfully authenticated user, write user informaiton to database  $$$$
                
                //firstly, create imageName and find storage reference
                let imageName = uid
                //let storageRef = Storage.storage().reference().child("Avatar_Images").child("\(imageName).png")
                let storageRef = Storage.storage().reference().child("Avatar_Images").child("\(imageName).jpg")
                if let avatarImage = self.Avatar.image, let uploadData = UIImageJPEGRepresentation(avatarImage, 0.1){
                //if let uploadData = UIImagePNGRepresentation(self.Avatar.image!) {
                    storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        if let avatarImageUrl = metadata?.downloadURL()?.absoluteString{
                                self.classTagValue.updateValue(true, forKey: self.classTextfield.text!)
                                let values = ["name": self.nameTextfield.text!, "email": self.emailTextfield.text!,
                                              "score": self.tempScore, "classTag": self.classTagValue, "avatarURL": avatarImageUrl] as [String : Any]
                                self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        }
                    })
                }
                //GO TO CHAT VIEW
                let tabBarViewControllor = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
                print("will change navigationItem title")
                //let chatViewControllor = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC")
                //chatViewControllor?.navigationItem.title = self.nameTextfield.text
                self.perform(#selector(self.waitMoment), with: nil, afterDelay: 3) //delay 3 seconds to chat view
                self.present(tabBarViewControllor!, animated: true, completion: nil)
            }
        })
    }
    
    @objc func waitMoment(){}
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]){
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid) // uid is primary key of a user
//        let values = ["name": self.nameTextfield.text!, "email": self.emailTextfield.text!, "avatarURL": userData?.downloadURL()!]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            //self.dismiss(animated: true, completion: nil)
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
