//
//  AlertViewController.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController{
    class func quickAlert(_ text:String, title:String, sender:UIViewController){
        let alert = UIAlertController(title: title, message:  text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        sender.present(alert, animated: true)
    }
}
