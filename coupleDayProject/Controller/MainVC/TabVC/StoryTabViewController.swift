//
//  StoryTabViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/07.
//

import UIKit

class StoryTabViewController: UIViewController {

    private var storyTabView: StoryTabView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyTabView = StoryTabView(frame: self.view.frame)
        self.storyTabView = StoryTabView()
        view.addSubview(storyTabView)
        
        storyTabView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storyTabView.topAnchor.constraint(equalTo: self.view.topAnchor),
            storyTabView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            storyTabView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            storyTabView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
    }
}
