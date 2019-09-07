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
    }
    
    @IBOutlet weak var username: UITextField!
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let text = username.text else {return}
        
        let api = ApiService()

//        api.signUp(username: text, completion: { success in
//            
//        })

        
    }
    
    
    func usernameShouldReturn(_ username: UITextField) -> Bool {
        //hide keyboard
        username.resignFirstResponder()
        return true
    }
    
    

        
    
    
    
    
}


