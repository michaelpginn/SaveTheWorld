//
//  FriendsViewController.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var textField:UITextField!
    
    var api:ApiService!
    var persistentStoreManager: PersistentStoreManager!
    var friendList:[Friend]{
        get{
            return persistentStoreManager.friendList
        }
        set(f){
            persistentStoreManager.friendList = f
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "friendCell")
        cell.textLabel?.text = friendList[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Courier", size: 17)
        return cell
    }
    
    @IBAction func addFriend(_ sender: UIButton){
        if let text = textField.text{
            guard !friendList.contains(text) else{
                UIAlertController.quickAlert("Error adding", title:"You already have this friend", sender:self)
                return
            }
            self.api.checkUsernameExists(username: text) { (success) in
                if(success){
                    self.friendList.append(text)
                    self.tableView.reloadData()
                }else{
                    UIAlertController.quickAlert("Error adding", title:"This user doesn't exist :(", sender:self)
                }
            }
        }
    }
}
