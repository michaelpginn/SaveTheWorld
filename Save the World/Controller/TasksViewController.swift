//
//  TasksViewController.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDataSource, TaskCellDelegate, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var persistentStore = PersistentStoreManager()
    var scoreManager = ScoreManager()
    var tasksStore: TasksStore!
    var api = ApiService()
    var loadingMore = false
    
    var lastTime = Date.timeIntervalSinceReferenceDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .TasksLoaded, object: nil)
        tableView.delegate = self
    }
    
    
    @objc func reloadTableData() {
        loadingMore = false
        tableView.reloadData()
    }
    
    func completeTask(task:Task){
        persistentStore.completeTask(task: task)
        api.postAction(action: Action(username: api.username!, title: task.name
            , description: "completed a task", taskId: task.id, dateTime: Date()))
        scoreManager.addPoints(points: task.points)
        NotificationCenter.default.post(name: .TaskCompleted, object: nil)
        self.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //use tasksStore[indexPath.row] to get each task
        let protoCell = tableView.dequeueReusableCell(withIdentifier: "protoCell")
        if let cellContent = protoCell?.viewWithTag(1) as? TaskCellView{
            let task = tasksStore[indexPath.row]
            if (task.points==1) {
                cellContent.titleLabel.text = "\(task.name) - \(task.points) point"
            }
            else {
                cellContent.titleLabel.text = "\(task.name) - \(task.points) points"
            }
            cellContent.descriptionLabel.text = task.description
            cellContent.delegate = self
            cellContent.task = task
            return protoCell!
        }else{
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if loadingMore || tasksStore.gotAll{
            return
        }
        
        let now = Date.timeIntervalSinceReferenceDate
        if now - self.lastTime < 3{
            return
        }
        self.lastTime = now
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            print("bottom of list")
            loadingMore = true
            tasksStore.loadMore()
        }
    }

    //when you reach the end you can call tasksStore.loadMore()
    @IBAction func quit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
