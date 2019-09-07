//
//  LaunchScreen.swift
//  Save the World
//
//  Created by Lucinda Gillespie on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreen: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        username.delegate = self
        let bgView = UIImageView(image: UIImage(named: "starsbg"))
        bgView.frame = view.frame
        view.addSubview(bgView)
        view.sendSubviewToBack(bgView)
        view.contentMode = .scaleAspectFill
    }
    
    @IBOutlet weak var username: UITextField!
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let text = username.text else {return}
        
        let api = ApiService()
        
        
        api.signUp(username: text, completion: { (success) in
            if success {
//                call uhhh what did i
                PersistentStoreManager().username = text
                self.dismiss(animated: true)
            }
            else {
                let alert = UIAlertController(title: "Username taken", message:  "HAHA SUX 4 U. That name is already taken. SUX 2 SUX", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: ":(", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        })
        
    }
    
    
    func usernameShouldReturn(_ username: UITextField) -> Bool {
        //hide keyboard
        username.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
    
    
}


