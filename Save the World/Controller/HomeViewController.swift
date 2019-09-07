//
//  HomeViewController.swift
//  Save the World
//
//  Created by Michael Ginn on 9/6/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let defaults = UserDefaults.standard
    let tasksStore = TasksStore()
    let persistentStoreManager = PersistentStoreManager()
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let bgView = UIImageView(image: UIImage(named: "starsbg"))
        bgView.frame = view.frame
        view.addSubview(bgView)
        view.sendSubviewToBack(bgView)
        view.contentMode = .scaleAspectFill
        
        tasksStore.loadMore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //check for first login
        if(persistentStoreManager.username == nil){
            self.performSegue(withIdentifier: "showSignup", sender: self)
        }
        else {
            self.usernameLabel.text = "\(persistentStoreManager.username ?? "")'s world"
            self.scoreLabel.text = "Score: \(persistentStoreManager.score)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTasks"{
            if let destVC = segue.destination as? TasksViewController{
                destVC.tasksStore = self.tasksStore
            }
        }
    }
}
