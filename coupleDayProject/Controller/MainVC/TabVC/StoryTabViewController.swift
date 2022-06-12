//
//  StoryTabViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/07.
//

import UIKit

class StoryTabViewController: UIViewController {
    
    private var storyTabView: StoryTabView!
    private var storyTabScrollView: StoryTabScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let storyTabView = StoryTabView(frame: self.view.frame)
        //        self.storyTabView = StoryTabView()
        //        view.addSubview(storyTabView)
        
        let storyTabScrollView = StoryTabScrollView(frame: self.view.frame)
        self.storyTabScrollView = StoryTabScrollView()
        view.addSubview(storyTabScrollView)
        
        storyTabScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storyTabScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            storyTabScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            storyTabScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            storyTabScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
    }
}
