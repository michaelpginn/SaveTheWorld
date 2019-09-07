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

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
        let bgView = UIImageView(image: UIImage(named: "starsbg"))
        view.addSubview(bgView)
        view.sendSubviewToBack(bgView)
        view.contentMode = .scaleAspectFill
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //check for first login
        if(defaults.string(forKey: "username") == nil){
            self.performSegue(withIdentifier: "showSignup", sender: self)
        }
        
    }

}
