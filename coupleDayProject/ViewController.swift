//
//  ViewController.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/08.
//

import UIKit

class ViewController: UIViewController {
    lazy var tempText: UILabel = {
       let view = UILabel()
        view.text = "Demo"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tempText)
        NSLayoutConstraint.activate([
            tempText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tempText.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

