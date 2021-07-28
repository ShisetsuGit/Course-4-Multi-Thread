//
//  TESTViewController.swift
//  UI_Project
//
//  Created by Shisetsu on 15.07.2021.
//

import UIKit

class TESTViewController: UIViewController {
    
    let newsRequest = APIRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsRequest.getNews()
    }
}
