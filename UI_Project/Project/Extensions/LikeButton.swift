//
//  LikeButton.swift
//  UI_Project
//
//  Created by  Shisetsu on 12.12.2020.
//


import UIKit

class LikeButton: UIButton {
    
    var likesCount:Int = 5
    var selectedImg = UIImage(named: "heart_full")
    var deselectedImg = UIImage(named: "heart_empty")
    
    var textColorDeselected:UIColor = UIColor.lightGray
    var textColorSelected:UIColor = UIColor.black
    
    var active:Bool = false
    
    override func draw(_ rect: CGRect) {
        
        if active {
            like()
            likesCount -= 1
        } else {
            dislike()
        }
        
        self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    
    @objc func onPress() {
        print("Button Pressed")
        active = !active
        
        if active {
            like()
        } else {
            dislike()
        }
    }
    
    func like() {
        likesCount += 1
        self.setImage(selectedImg, for: .normal)
        self.setTitle("\(likesCount)", for: .normal)
        self.setTitleColor(textColorSelected, for: .normal)
        
        let beat = CASpringAnimation(keyPath: "transform.scale")
        beat.duration = 0.6
        beat.fromValue = 1.0
        beat.toValue = 1.12
        beat.autoreverses = true
        beat.repeatCount = 1
        beat.initialVelocity = 0.5
        beat.damping = 0.8
        
        let animation = CAAnimationGroup()
        animation.duration = 2.7
        animation.repeatCount = 1
        animation.animations = [beat]
        
        layer.add(animation, forKey: "beat")
    }
    
    func dislike() {
        likesCount -= 1
        self.setImage(deselectedImg, for: .normal)
        self.setTitle("\(likesCount)", for: .normal)
        self.setTitleColor(textColorDeselected, for: .normal)
    }
    
}
