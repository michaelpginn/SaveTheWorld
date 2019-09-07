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
    
    @IBOutlet var tasksView:UIView!
    
    var limit:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let bgView = UIImageView(image: UIImage(named: "starsbg"))
        view.addSubview(bgView)
        view.sendSubviewToBack(bgView)
        view.contentMode = .scaleAspectFill
        
        limit =  UIScreen.main.bounds.size.height - (self.tasksView.frame.height * 0.40)
        print("LIMIT \(limit)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //check for first login
        if(defaults.string(forKey: "username") == nil){
            self.performSegue(withIdentifier: "showSignup", sender: self)
        }
        
    }
    
    var initialCenter = CGPoint()
    var iy: CGFloat{
        get{
            return initialCenter.y
        }
    }
    var ix: CGFloat {
        get{
            return initialCenter.x
        }
    }
    
    @IBAction func slideTasksView(_ gestureRec: UIPanGestureRecognizer) {
        
        guard let card = gestureRec.view else {return}
        let translation = gestureRec.translation(in: card.superview)
        var transY = translation.y
        
        if gestureRec.state == .began{
            self.initialCenter = card.center
        }
        
        if gestureRec.state != .cancelled{
            if card.center.y + translation.y < limit {
                let offset = (limit - (card.center.y + translation.y))/10
                print("offset\t\(offset)")
                transY = transY * CGFloat((powf(0.5, Float(offset))))
                print("transY\t\(offset)")
            }
            let newCenter = CGPoint(x: initialCenter.x, y: initialCenter.y + transY)
            card.center = newCenter
            
        }
        
        else {
            card.center = initialCenter
        }
    }
}
