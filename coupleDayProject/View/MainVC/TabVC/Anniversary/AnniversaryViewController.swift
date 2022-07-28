import UIKit

class AnniversaryViewController: UIViewController {
    
    private let anniversaryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.anniversaryTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bgColor")
        anniversaryTableView.backgroundColor = UIColor(named: "bgColor")
        
        anniversaryTableView.register(AnniversaryCell.self, forCellReuseIdentifier: "AnniversaryTableViewCell")
        anniversaryTableView.delegate = self
        anniversaryTableView.dataSource = self
        anniversaryTableView.separatorStyle = .none
        
        self.view.addSubview(anniversaryTableView)
        
        // set autolayout
        //
        NSLayoutConstraint.activate([
            anniversaryTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            anniversaryTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            anniversaryTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            anniversaryTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        anniversaryTableView.rowHeight = 120
        anniversaryTableView.estimatedRowHeight = UITableView.automaticDimension
    }
}


extension AnniversaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 현재 날짜 기준으로 지나지 않은 기념일 다 불러옴
        //
        let nowDate = Date().millisecondsSince1970
        let anniversaryFilter = Anniversary().AnniversaryModel.filter { dictValue in
            let keyValue = dictValue.keys.first
            if nowDate < (keyValue?.toDate.millisecondsSince1970)! {
                return true
            } else {
                return false
            }
        }
        return anniversaryFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnniversaryTableViewCell", for: indexPath) as? AnniversaryCell ?? AnniversaryCell()
//        cell.bind(index: StoryDay().storyArray[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "bgColor")
        return cell
    }
}
