//
//  StoryTabViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/07.
//

import UIKit

class StoryTabViewController: UIViewController {
    lazy var tempText: UILabel = {
       let view = UILabel()
        view.text = "Story"
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
