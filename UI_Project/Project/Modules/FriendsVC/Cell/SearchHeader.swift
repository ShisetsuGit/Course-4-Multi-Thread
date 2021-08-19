//
//  SearchHeader.swift
//  UI_Project
//
//  Created by Shisetsu on 15.08.2021.
//

import UIKit

class SearchHeader: UIView {

    lazy var headerView: UIView = {
        
        let header = UIView(frame: CGRect(x: 30, y: 20, width: 42, height: 42))
        header.backgroundColor = UIColor.lightGray
        header.alpha = 0.5
        
        let label = UILabel(frame: CGRect(x: 4, y: 4, width: 160, height: 20))
        label.textColor = .black
        label.text = "Результат поиска"
        header.addSubview(label)
        
        return header
    }()

}
