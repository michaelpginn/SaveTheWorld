//
//  FeedViewController.swift
//  Save the World
//
//  Created by Lucinda Gillespie on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {

    var actions: [Action] = []
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
                self.actions.append(contentsOf: actionList)
                self.feedTable.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("M/d/yy")
        
        let cell = UITableViewCell(style: .value2, reuseIdentifier: "feedCell")
        var action = actions[indexPath.row]
        
        let date = Date(timeIntervalSince1970: action.dateTime.timeIntervalSince1970)
        
        cell.textLabel?.text = dateFormatter.string(from: date)
        cell.textLabel?.font = UIFont(name: "Courier", size: 17)
        cell.detailTextLabel?.text = ("\(action.username) completed task:\n\"\(action.title)\"")
        cell.detailTextLabel?.numberOfLines = 2
        cell.detailTextLabel?.font = UIFont(name: "Courier", size: 17)
        return cell
    }

}
