import UIKit

class StoryTabViewController: UIViewController {

    // MARK: UI
    //
    private let emptyView: UIView = { // 상단 탭이랑 안겹치게 주는 뷰
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    private let storyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: init
    //
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [self] in
            storyTableView.reloadData()
        }
        
        // 날짜 안지난 스토리로 스크롤 이동
        //
        let startIndex = IndexPath(row: StoryDay().storyArray.firstIndex(of: StoryDay().storyArray.filter {$0 > Int(CoupleTabViewModel.publicBeginCoupleDay)!}.min()!)!, section: 0)
        self.storyTableView.scrollToRow(at: startIndex, at: .top, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "bgColor")
        storyTableView.backgroundColor = UIColor(named: "bgColor")
        
        storyTableView.register(StoryCell.self, forCellReuseIdentifier: "CodingCustomTableViewCell")
        storyTableView.delegate = self
        storyTableView.dataSource = self
        storyTableView.separatorStyle = .none
        
        self.view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(emptyView)
        contentStackView.addArrangedSubview(storyTableView)
        
        // set autolayout
        //
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 70),
            
            storyTableView.topAnchor.constraint(equalTo: self.emptyView.bottomAnchor),
            storyTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            storyTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            storyTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        storyTableView.rowHeight = 100
        storyTableView.estimatedRowHeight = UITableView.automaticDimension   
    }
}

// MARK: extension
//
extension StoryTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoryDay().storyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodingCustomTableViewCell", for: indexPath) as? StoryCell ?? StoryCell()
        cell.bind(index: StoryDay().storyArray[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "bgColor")
        return cell
    }
}
