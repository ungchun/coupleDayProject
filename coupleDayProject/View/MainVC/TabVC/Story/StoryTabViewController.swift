//
//  StoryTabViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/07.
//

import UIKit

struct DemoData {
    var storyArray = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 365, 400, 500, 600, 700, 730]
}

extension StoryTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoData().storyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodingCustomTableViewCell", for: indexPath) as? StoryCell ?? StoryCell()
        cell.bind(index: DemoData().storyArray[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
}

class StoryTabViewController: UIViewController {
    
    // MARK: UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // 상단 탭이랑 안겹치게 주는 뷰
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cyan
        return view
    }()
    
    // scrollView (stackView)
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    
    // emptyView + contentStackView
    private lazy var entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [self] in
            print("DispatchQueue")
            tableView.reloadData()
        }
//        if CoupleTabViewModel.changeCoupleDayStoryCheck {
//            DispatchQueue.main.async { [self] in
//                tableView.reloadData()
//            }
//            CoupleTabViewModel.changeCoupleDayStoryCheck = false
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StoryCell.self, forCellReuseIdentifier: "CodingCustomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        self.view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(emptyView)
        contentStackView.addArrangedSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: self.emptyView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = UITableView.automaticDimension   
    }
}
