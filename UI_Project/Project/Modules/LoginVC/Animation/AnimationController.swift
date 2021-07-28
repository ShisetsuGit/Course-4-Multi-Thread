//
//  AnimationController.swift
//  UI_Project
//
//  Created by  Shisetsu on 27.12.2020.
//

import UIKit
import Lottie

class AnimationController: UIViewController {
    
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView = .init(name: "Christmas")
        
        animationView!.frame = view.bounds
        
        animationView!.contentMode = .scaleAspectFit
        
        animationView!.animationSpeed = 0.5
        
        view.addSubview(animationView!)
        
        animationView!.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginScreen") as! LoginController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
        }
        
    }
    
}
