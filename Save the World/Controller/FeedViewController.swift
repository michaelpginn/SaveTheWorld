//
//  FeedViewController.swift
//  Save the World
//
//  Created by Lucinda Gillespie on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {

    var actionList: [Action]?
    var api = ApiService()
    var persistantStore = PersistentStoreManager()
    
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet var feedTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.getFeed(friendList: persistantStore.friendList) { (actionList, error) in
            if let actionList = actionList{
                self.actionList?.append(contentsOf: actionList)
                
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(friendList)
//        return friendList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "friendCell")
//        cell.textLabel?.text = friendList[indexPath.row]
//        cell.textLabel?.font = UIFont(name: "Courier", size: 17)
//        return cell
//    }

}
