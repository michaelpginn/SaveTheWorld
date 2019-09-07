//
//  TasksViewController.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var persistentStore = PersistentStoreManager()
    var tasksStore: TasksStore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let longPressRecognize = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognize)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == .began {
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint){
                persistentStore.completeTask(task: tasksStore[indexPath.row])
                self.dismiss(animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tasksStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //use tasksStore[indexPath.row] to get each task
        let cell = UITableViewCell(style: .default, reuseIdentifier: "task")
        
        let task = tasksStore[indexPath.row]
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.description
        return cell
    }

    //when you reach the end you can call tasksStore.loadMore()
    @IBAction func quit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
