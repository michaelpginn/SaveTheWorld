//
//  TaskCellVIew.swift
//  Save the World
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import UIKit

class TaskCellView: UIView {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var progressBar:UIView!
    
    var timer:Timer?
    var animator:UIViewPropertyAnimator?
    var bar:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 9))
        subview.backgroundColor = UIColor(displayP3Red: 107/255.0, green: 147/255.0, blue: 214/255.0, alpha: 1.0)
        self.progressBar.addSubview(subview)
        print(progressBar.frame)
        self.bar = subview
        
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            print("done")
        }
        self.animator = UIViewPropertyAnimator(duration: 1.5, curve: .linear, animations: {
            self.bar?.frame = CGRect(x: 0, y: 0, width: self.progressBar.frame.width, height: 9)
        })
        self.animator?.addCompletion({ (position) in
            self.bar?.removeFromSuperview()
            self.bar = nil
            //actually run the event
        })
        self.animator?.startAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.timer?.invalidate()
        self.bar?.removeFromSuperview()
        self.bar = nil
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.timer?.invalidate()
        self.bar?.removeFromSuperview()
        self.bar = nil
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
            
        }
    }
}
