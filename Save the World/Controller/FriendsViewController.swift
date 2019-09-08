//
//  FriendsViewController.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var friendTable:UITableView!
    @IBOutlet weak var friendSearch:UITextField!
    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    var api = ApiService()
    var persistentStoreManager = PersistentStoreManager()
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
        print(friendList)
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "friendCell")
        cell.textLabel?.text = friendList[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Courier", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friendList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addFriend(_ sender: UIButton){
        if let text = friendSearch.text{
            friendSearch.text = ""
            if friendList.contains(text) {
                UIAlertController.quickAlert("You already have this friend", title:"Error adding", sender:self)
                return
            }
            self.api.checkUsernameExists(username: text) { (success) in
                if(success && text != self.api.username){
                    self.friendList.append(text)
                    self.friendTable.reloadData()
                }else{
                    UIAlertController.quickAlert("Error adding", title:"This user doesn't exist :(", sender:self)
                }
            }
        }
    }
}
