import UIKit

final class StoryTabViewController: UIViewController {
    
    // MARK: Properties
    //
    private var coupleTabViewModel: CoupleTabViewModel?
    
    // MARK: Views
    //
    private let topEmptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let storyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    private let allContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    init(coupleTabViewModel: CoupleTabViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.coupleTabViewModel = coupleTabViewModel
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveCoupleDayData(notification:)),
            name: Notification.Name.coupleDay, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeDarkModeSet(notification:)),
            name: Notification.Name.darkModeCheck, object: nil
        )
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let coupleTabViewModel = coupleTabViewModel else { return }
        if Int((coupleTabViewModel.beginCoupleDay.value))! >= 10950 {
            let startIndex = IndexPath(row: StoryStandardDayModel().dayValues.count-1, section: 0)
            self.storyTableView.scrollToRow(at: startIndex, at: .top, animated: false)
        } else {
            let startIndex = IndexPath(
                row: StoryStandardDayModel().dayValues.firstIndex(
                    of: StoryStandardDayModel().dayValues.filter {
                        $0 > Int((coupleTabViewModel.beginCoupleDay.value))!
                    }.min()!)!,
                section: 0
            )
            self.storyTableView.scrollToRow(at: startIndex, at: .top, animated: false)
        }
    }
    
    // MARK: Functions
    //
    private func setUpView() {
        guard let coupleTabViewModel = coupleTabViewModel else { return }
        self.view.backgroundColor = UIColor(named: "bgColor")
        
        storyTableView.backgroundColor = UIColor(named: "bgColor")
        storyTableView.register(
            StoryTableViewCell.self,
            forCellReuseIdentifier: "CodingCustomTableViewCell"
        )
        storyTableView.delegate = self
        storyTableView.dataSource = self
        storyTableView.separatorStyle = .none
        
        self.view.addSubview(allContentStackView)
        allContentStackView.addArrangedSubview(topEmptyView)
        allContentStackView.addArrangedSubview(storyTableView)
        
        NSLayoutConstraint.activate([
            topEmptyView.topAnchor.constraint(equalTo: view.topAnchor),
            topEmptyView.heightAnchor.constraint(equalToConstant: 70),
            
            storyTableView.topAnchor.constraint(equalTo: self.topEmptyView.bottomAnchor),
            storyTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            storyTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            storyTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        storyTableView.rowHeight = 80
        storyTableView.estimatedRowHeight = UITableView.automaticDimension
        
        if Int((coupleTabViewModel.beginCoupleDay.value))! >= 10950 {
            let startIndex = IndexPath(row: StoryStandardDayModel().dayValues.count-1, section: 0)
            self.storyTableView.scrollToRow(at: startIndex, at: .top, animated: false)
        } else {
            let startIndex = IndexPath(
                row: StoryStandardDayModel().dayValues.firstIndex(
                    of: StoryStandardDayModel().dayValues.filter {
                        $0 > Int((coupleTabViewModel.beginCoupleDay.value))!}.min()!)!,
                section: 0
            )
            self.storyTableView.scrollToRow(at: startIndex, at: .top, animated: false)
        }
    }
    
    @objc func receiveCoupleDayData(notification: Notification) {
        storyTableView.register(
            StoryTableViewCell.self,
            forCellReuseIdentifier: "CodingCustomTableViewCell"
        )
        storyTableView.delegate = self
        storyTableView.dataSource = self
        
        guard let object = notification.userInfo?["coupleDay"] as? String else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.storyTableView.reloadData()
            if Int(object)! >= 10950 {
                let startIndex = IndexPath(
                    row: StoryStandardDayModel().dayValues.count-1,
                    section: 0
                )
                self?.storyTableView.scrollToRow(at: startIndex, at: .top, animated: false)
            } else {
                let startIndex = IndexPath(
                    row: StoryStandardDayModel().dayValues.firstIndex(
                        of: StoryStandardDayModel().dayValues.filter {$0 > Int(object)!}.min()!)!,
                    section: 0
                )
                self?.storyTableView.scrollToRow(at: startIndex, at: .top, animated: false)
            }
        }
    }
    
    @objc private func changeDarkModeSet(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.storyTableView.reloadData()
        }
    }
}

// MARK: Extension
//
extension StoryTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoryStandardDayModel().dayValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CodingCustomTableViewCell",
            for: indexPath
        ) as? StoryTableViewCell ?? StoryTableViewCell()
        if let coupleTabViewModel = coupleTabViewModel {
            cell.setStoryCellText(
                index: StoryStandardDayModel().dayValues[indexPath.row],
                beginCoupleDay: coupleTabViewModel.beginCoupleDay.value
            )
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "bgColor")
        }
        return cell
    }
}
