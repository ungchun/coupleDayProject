//
//  StoryTabViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/07.
//

import UIKit


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
        view.backgroundColor = .white
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
        
        // 날짜 안지난 스토리로 스크롤 이동
        let startIndex = IndexPath(row: StoryDay().storyArray.firstIndex(of: StoryDay().storyArray.filter {$0 > Int(CoupleTabViewModel.publicBeginCoupleDay)!}.min()!)!, section: 0)
        self.tableView.scrollToRow(at: startIndex, at: .top, animated: false)
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
            emptyView.heightAnchor.constraint(equalToConstant: 70),
            
            tableView.topAnchor.constraint(equalTo: self.emptyView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = UITableView.automaticDimension   
    }
}

// tableView extension
extension StoryTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoryDay().storyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodingCustomTableViewCell", for: indexPath) as? StoryCell ?? StoryCell()
        // 여기서 textColor black 으로 안해주면 cell 재사용하기때문에 날짜 지난 컬러 셀을 재사용해서 gray textColor가 원하지 않는 곳에 들어감
//        cell.storyDayText.textColor = .black
        cell.bind(index: StoryDay().storyArray[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
}
