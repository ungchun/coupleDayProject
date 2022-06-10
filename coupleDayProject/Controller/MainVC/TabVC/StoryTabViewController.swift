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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "10일"
        view.backgroundColor = .gray
        return view
    }()
    lazy var tempText3: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "10일"
        view.backgroundColor = .gray
        return view
    }()

    lazy var tempText1: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "2022.06.06(월)"
        view.backgroundColor = .blue
        return view
    }()
    lazy var tempText4: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "2022.06.06(월)"
        view.backgroundColor = .blue
        return view
    }()

    lazy var demoDivider: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    lazy var demoDivider1: UILabel = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan
        return view
    }()
    
    lazy var emptyView1: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()
    lazy var emptyView2: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        emptyView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // content (가운데 들어갈 글자들)
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let stackView1 = UIStackView(arrangedSubviews: [tempText,tempText1])
        stackView1.axis = .vertical
        stackView1.alignment = .fill
//        stackView.spacing = 10
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView2 = UIStackView(arrangedSubviews: [emptyView1, stackView1, demoDivider])
        stackView2.axis = .vertical
        stackView2.alignment = .fill
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.spacing = 30
//        emptyView1.bottomAnchor.constraint(equalTo: tempText.topAnchor, constant: -10).isActive = true
        emptyView1.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        demoDivider.topAnchor.constraint(equalTo: tempText1.bottomAnchor, constant: 10).isActive = true
        demoDivider.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        let demoStackView = UIStackView(arrangedSubviews: [tempText3,tempText4])
        demoStackView.axis = .vertical
        demoStackView.alignment = .fill
//        stackView.spacing = 10
        demoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView3 = UIStackView(arrangedSubviews: [emptyView2, demoStackView, demoDivider1])
        stackView3.axis = .vertical
        stackView3.alignment = .fill
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        stackView3.spacing = 30
//        emptyView1.bottomAnchor.constraint(equalTo: tempText.topAnchor, constant: -10).isActive = true
        emptyView2.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        demoDivider.topAnchor.constraint(equalTo: tempText1.bottomAnchor, constant: 10).isActive = true
        demoDivider1.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emptyView, stackView2, stackView3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
//        stackView.spacing = 10
        
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        

        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
}
