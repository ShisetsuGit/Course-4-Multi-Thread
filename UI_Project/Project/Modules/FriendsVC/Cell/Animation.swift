//
//  Animation.swift
//  UI_Project
//
//  Created by Shisetsu on 15.08.2021.
//

import Foundation
import UIKit

class Animation {
    
    lazy var friendSpringAnimation: CASpringAnimation = {
        let spring = CASpringAnimation(keyPath: "transform.scale")
        spring.duration = 0.5
        spring.damping = 0.1
        spring.initialVelocity = 0.1
        spring.fromValue = 1
        spring.toValue = 0.9
        return spring
    }()
    
    lazy var friendAnimationGroup: CAAnimationGroup = {
        let animation = CAAnimationGroup()
        animation.duration = 1
        animation.animations = [Animation().friendSpringAnimation]
        return animation
    }()
    
}
