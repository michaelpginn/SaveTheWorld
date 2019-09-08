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
    var scoreManager = ScoreManager()
    var tasksStore: TasksStore!
    var api = ApiService()
    
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
                let task = tasksStore[indexPath.row]
                persistentStore.completeTask(task: task)
                api.postAction(action: Action(username: api.username!, description: "completed a task", taskId: task.id, dateTime: Date()))
                scoreManager.addPoints(points: tasksStore[indexPath.row].points)
                NotificationCenter.default.post(name: .TaskCompleted, object: nil)
                self.dismiss(animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tasksStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //use tasksStore[indexPath.row] to get each task
        let protoCell = tableView.dequeueReusableCell(withIdentifier: "protoCell")
        let textLabel = protoCell?.viewWithTag(1) as! UILabel
        let textLabel2 = protoCell?.viewWithTag(2) as! UILabel
        
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "task")
        
        let task = tasksStore[indexPath.row]
        if (task.points==1) {
            textLabel.text = "\(task.name) - \(task.points) point"
        }
        else {
            textLabel.text = "\(task.name) - \(task.points) points"
        }
        textLabel2.text = task.description
        return protoCell!
    }

    //when you reach the end you can call tasksStore.loadMore()
    @IBAction func quit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
