//
//  NewMessageViewController.swift
//  ClassHero
//
//  Created by ouyang chenxing on 02/19/18.
//  Copyright © 2018 CSE437. All rights reserved.

import UIKit
import Firebase
//this is the contacts table view, by click right nav bar, we can come here, our contacts will show here
class NewMessageViewController: UITableViewController, UITextFieldDelegate {
    
    let cellId = "cellId"
    var contacts = [Contact]()
    var tempTagsList = [Contact]()
    var allContacts = [Contact]()
    var searchTagsField: UITextField?
    //var arrayScores = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(self.searchTags))
        //add a back button, back to chat view
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
        
        
        //       navigationController?.
    }
    
    @objc func searchTags(){
        let rateWindow = UIAlertController(title: "SEARCH", message: "Type one class tag to find your classmates e.g: CSE437", preferredStyle: .alert)
        rateWindow.addTextField {searchField -> Void in
            searchField.delegate = self
        }
        let okAction = UIAlertAction(title: "submit", style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        rateWindow.addAction(cancelAction)
        rateWindow.addAction(okAction)
        self.present(rateWindow, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchTagsField = textField
        searchTagsField?.placeholder = "e.g: CSE437"
        return true
    }
    
    //update table view
    func okHandler(alert:UIAlertAction) {
        for eachContact in allContacts {
            for key in (eachContact.classTag?.keys)! {
                if key == searchTagsField?.text {
                    //print(eachContact.classTag![key])
                    if eachContact.classTag![key] == true {
                        self.tempTagsList.append(eachContact)
                    }
                }
            }
        }
        self.contacts.removeAll()
        tempTagsList.sort(by: {$0.score! > $1.score!})
        for contact in tempTagsList {
            self.contacts.append(contact)
        }
        self.tempTagsList.removeAll()
        self.tableView.reloadData()
    }
    
    //sorted function
    
    
    //fetch users in the firebase
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let contact = Contact(dictionary: dictionary)
                contact.id = snapshot.key
                //get inforamtion from dictionary
                contact.name = dictionary["name"] as? String
                contact.email = dictionary["email"] as? String
                contact.score = dictionary["score"] as? Int
                contact.avatarURL = dictionary["avatarURL"] as? String
                contact.classTag = dictionary["classTag"] as? [String: Bool]
                //print(contact.name!, contact.email!)
                //add contact to contacts
                self.contacts.append(contact)
                self.allContacts.append(contact)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //    //back to chat view
    //    @objc func handleBack() {
    //        dismiss(animated: true, completion: nil)
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //default tableViewCell
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        //customized tableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        contacts.sort(by: {$0.score! > $1.score!})
        
        let contact = contacts[indexPath.row]
        cell.timeLabel.text = ""
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = "rate: " + String(contact.score!)
        ///****** display score here
        cell.avatarImageView.image = UIImage(named: "default-avatar")
        //cell.imageView?.image = UIImage(named: "default-avatar")
        //cell.imageView?.contentMode =
        
        //$$$$  GET Avatar from database  $$$$$
        if let avatarURL = contact.avatarURL {
            cell.avatarImageView.loadImageUsingCacheWithURL(urlString: avatarURL)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let a = indexPath.row
        let receiverInfo = self.contacts[a]
        print(indexPath.row)
        _ = Database.database().reference()
        
        //        let usersReference = ref.child("users").child("messageTo") // uid is primary key of a user
        //        //        let values = ["name": self.nameTextfield.text!, "email": self.emailTextfield.text!, "avatarURL": userData?.downloadURL()!]
        //        usersReference.updateChildValues(messageInfo, withCompletionBlock: { (err, ref) in
        //            if let err = err {
        //                print(err)
        //                return
        //            }
        //            //self.dismiss(animated: true, completion: nil)
        //        })
        
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.hidesBottomBarWhenPushed = true
        chatLogController.receiver = receiverInfo
        chatLogController.title = receiverInfo.name
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}
