import UIKit

final class StoryTabViewController: UIViewController {
    
    // CoupleTabViewController의 coupleTabViewModel!.beginCoupleDay.bind 처럼 바인드를 이용해서 데이터를 업데이트 시켜주지않고
    // 왜 노티피케이션 센터를 썼냐? -> 원래는 ContainerViewModelCombine, StoryTabViewController 에도 bind를 사용하고 있었는데 (3개)
    // Observable로 bind가 호출되면 3개가 다 바뀌는게 아니라 한 곳만 바뀌고 나머지는 안바뀌는 현상이 나타났음.
    // 따라서 메인인 CoupleTabViewController에만 bind 사용하고 나머지 두 곳은 주입한 coupleTabViewModel로 첫 세팅만 해주고
    // 커플 날짜 값이 바뀌면 노티피케이션 센터로 나머지 두 곳에 데이터 변경시킴
    //
    private var coupleTabViewModel: CoupleTabViewModel?
    init(coupleTabViewModel: CoupleTabViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.coupleTabViewModel = coupleTabViewModel
        
        // Notification Center에 Observer 등록
        //
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
    @objc func receiveCoupleDayData(notification: Notification) {
        // notification.userInfo 값을 받아온다. -> 그 값을 가지고 scrollToRow 처리
        //
        storyTableView.register(
            StoryTableViewCell.self,
            forCellReuseIdentifier: "CodingCustomTableViewCell"
        )
        storyTableView.delegate = self
        storyTableView.dataSource = self
        guard let object = notification.userInfo?["coupleDay"] as? String else {
            return
        }
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
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
        
        // 날짜 안지난 스토리로 스크롤 이동
        // if CoupleDay 10년 이상이면 10주년 story 로 이동 (우선 story 30주년 까지 설정)
        //
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
