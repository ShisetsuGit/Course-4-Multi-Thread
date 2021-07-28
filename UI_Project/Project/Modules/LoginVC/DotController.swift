//
//  DotController.swift
//  UI_Project
//
//  Created by  Shisetsu on 30.12.2020.
//

import UIKit

class DotController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dotedView = UIView(frame: CGRect(x: 4, y: 6, width:100, height: 50))
        dotedView.backgroundColor = .clear
        dotedView.center = CGPoint(x: self.view.frame.size.width  / 2,
                                   y: self.view.frame.size.height / 2)
        let firstDot = UIView(frame: CGRect(x: 4, y: 6, width:5, height: 5))
        firstDot.backgroundColor = .red
        firstDot.center = CGPoint(x: (self.view.frame.size.width / 2) - 10,
                                  y: (self.view.frame.size.height / 2))
        firstDot.layer.cornerRadius = firstDot.frame.height / 2
        let secondtDot = UIView(frame: CGRect(x: 4, y: 6, width:5, height: 5))
        secondtDot.backgroundColor = .green
        secondtDot.center = CGPoint(x: self.view.frame.size.width / 2,
                                    y: self.view.frame.size.height / 2)
        secondtDot.layer.cornerRadius = firstDot.frame.height / 2
        let thirdtDot = UIView(frame: CGRect(x: 4, y: 6, width:5, height: 5))
        thirdtDot.backgroundColor = .blue
        thirdtDot.center = CGPoint(x: (self.view.frame.size.width / 2) + 10,
                                   y: (self.view.frame.size.height / 2))
        thirdtDot.layer.cornerRadius = firstDot.frame.height / 2
        
        self.view.addSubview(dotedView)
        self.view.addSubview(firstDot)
        self.view.addSubview(secondtDot)
        self.view.addSubview(thirdtDot)
        
        
        UIView.animateKeyframes(withDuration: 2,
                                delay: 0,
                                options: .beginFromCurrentState,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15) {
                                        firstDot.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.3) {
                                        secondtDot.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.45) {
                                        thirdtDot.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 0.6) {
                                        firstDot.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.75) {
                                        secondtDot.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.8) {
                                        thirdtDot.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                    }
                                })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LottieAnimation") as! AnimationController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }
        
    }
    
    
}
