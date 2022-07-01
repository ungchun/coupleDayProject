//
//  StoryTabViewController.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/07.
//

import UIKit

extension StoryTabDemoViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodingCustomTableViewCell", for: indexPath) as? StoryDemoCell ?? StoryDemoCell()
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CodingCustomTableViewCell", for: indexPath)
//        cell.textLabel?.text = "1235"
        return cell
    }
}

class StoryTabDemoViewController: UIViewController {
   
    let storyTabViewModel = StoryTabViewModel()
    
//    var testA = CoupleTabViewModel.publicBeginCoupleDay
//    var testB = CoupleTabViewModel.publicBeginCoupleFormatterDay
    
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
        //        let stackView = UIStackView(arrangedSubviews: [emptyView])
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
//        tableView.backgroundColor = .blue
        return tableView
    }()
//
//    // MARK: func
//    fileprivate func setupView() {
//        print("story setUpView")
//        view.addSubview(scrollView)
//        view.addSubview(entireStackView)
//        entireStackView.addArrangedSubview(emptyView)
//        entireStackView.addArrangedSubview(scrollView)
//
//        for i in stride(from: 0, to: 100, by: 10) {
//            if i == 0 {
//                let storyTabView = StoryCell(frame: view.frame, day: Int.max, testA: self.testA, testB: self.testB)
//                contentStackView.addArrangedSubview(storyTabView)
//            } else {
//                let storyTabView = StoryCell(frame: view.frame, day: i, testA: self.testA, testB: self.testB)
//                contentStackView.addArrangedSubview(storyTabView)
//            }
//        }
//
//        for i in stride(from: 100, to: 3000, by: 100) {
//            let dividerValue = i / 365
//            let demoDividerValue = i % 365
//            if dividerValue >= 1 && demoDividerValue < 100 {
//                let storyTabView = StoryCell(frame: view.frame, day: dividerValue * 365, testA: self.testA, testB: self.testB)
//                contentStackView.addArrangedSubview(storyTabView)
//            }
//            let storyTabView = StoryCell(frame: view.frame, day: i, testA: self.testA, testB: self.testB)
//            contentStackView.addArrangedSubview(storyTabView)
//        }
//
//        scrollView.addSubview(contentStackView)
//        NSLayoutConstraint.activate([
//
//            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
//            emptyView.heightAnchor.constraint(equalToConstant: 100),
//
//            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            scrollView.topAnchor.constraint(equalTo: emptyView.bottomAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        //        self.view.setNeedsLayout()c
//        //        self.view.layoutIfNeeded()
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        //        setupView()
//        //         커플날짜 변경됐을때
//        if CoupleTabViewModel.changeCoupleDayStoryCheck {
//            CoupleTabViewModel().updatePublicBeginCoupleDay()
//            CoupleTabViewModel().updatePublicBeginCoupleFormatterDay()
//
//            storyTabViewModel.updateTest()
//
//            print("BBBB \(CoupleTabViewModel.publicBeginCoupleDay)")
//
//
////            setupView()
////            self.view.setNeedsDisplay()
////            self.view.layoutIfNeeded()
//
//            //            self.loadView()
//
//
//            //            entireStackView.reloadInputViews()
//
//            //            //                        scrollView.setNeedsLayout()
//            //            contentStackView.layoutIfNeeded()
//            //            scrollView.layoutIfNeeded()
//            //            //                        entireStackView.setNeedsLayout()
//            //            entireStackView.layoutIfNeeded()
//            CoupleTabViewModel.changeCoupleDayStoryCheck = false
//            //            self.view.setNeedsLayout()
//
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StoryDemoCell.self, forCellReuseIdentifier: "CodingCustomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)

           tableView.translatesAutoresizingMaskIntoConstraints = false

               

           NSLayoutConstraint.activate([

              tableView.topAnchor.constraint(equalTo: self.view.topAnchor),

              tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

              tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),

              tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
              ])
        
        
        
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        
//        tableView.rowHeight = 100
//        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
        
        
//        tableView.register(StoryCell.self, forCellReuseIdentifier: "StoryCell")
        
//        print("story viewDidLoad 11111")
//        storyTabViewModel.onUpdatedLabels = {
//            DispatchQueue.main.async { [self] in
//                testA = CoupleTabViewModel.publicBeginCoupleDay
//                testB = CoupleTabViewModel.publicBeginCoupleFormatterDay
//            }
//        }
//        testA = CoupleTabViewModel.publicBeginCoupleDay
//        testB = CoupleTabViewModel.publicBeginCoupleFormatterDay
//        print("story viewDidLoad 22222")
//        print("CoupleTabViewModel.publicBeginCoupleDay \(CoupleTabViewModel.publicBeginCoupleDay)")
//        print("testA \(testA)")
//        setupView()
        
    }
}
