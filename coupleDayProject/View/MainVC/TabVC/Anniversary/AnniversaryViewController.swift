import UIKit
import GoogleMobileAds

class AnniversaryViewController: UIViewController {
    
    // MARK: UI
    //
    private let anniversaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "커플 기념일"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    private let anniversaryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let divider: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    private let admobView: GADBannerView = {
        var view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let anniversaryTopStackView: UIStackView = { // label
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    private let anniversaryStackView: UIStackView = { // label + divider + tableView + admob
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    // MARK: init
    //
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
        
        view.addSubview(anniversaryTopStackView)
        anniversaryTopStackView.addArrangedSubview(anniversaryLabel)
        
        view.addSubview(anniversaryStackView)
        anniversaryStackView.addArrangedSubview(anniversaryTopStackView)
        anniversaryStackView.addArrangedSubview(divider)
        anniversaryStackView.addArrangedSubview(anniversaryTableView)
        anniversaryStackView.addArrangedSubview(admobView)
        
        admobView.widthAnchor.constraint(equalToConstant: GADAdSizeBanner.size.width).isActive = true
        admobView.heightAnchor.constraint(equalToConstant: GADAdSizeBanner.size.height).isActive = true
        // ca-app-pub-1976572399218124/5279479661 -> 광고 단위 ID
        // ca-app-pub-3940256099942544/2934735716 -> test Key
        admobView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        admobView.rootViewController = self
        admobView.load(GADRequest())
        admobView.delegate = self
        
        let tapcloseBtn = UITapGestureRecognizer(target: self, action: #selector(tapClose))
        
        anniversaryTopStackView.isUserInteractionEnabled = true
        anniversaryTopStackView.addGestureRecognizer(tapcloseBtn)
        
        // set autolayout
        //
        NSLayoutConstraint.activate([
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            anniversaryTopStackView.heightAnchor.constraint(equalToConstant: 50),
            
            anniversaryStackView.topAnchor.constraint(equalTo: self.view.topAnchor ,constant: 5),
            anniversaryStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            anniversaryStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            anniversaryStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        anniversaryTableView.rowHeight = 140
        anniversaryTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    // MARK: objc
    //
    @objc
    func tapClose() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: extension
//
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
        let nowDate = Date().millisecondsSince1970
        let anniversaryFilter = Anniversary().AnniversaryModel.filter { dictValue in
            let keyValue = dictValue.keys.first
            if nowDate < (keyValue?.toDate.millisecondsSince1970)! {
                return true
            } else {
                return false
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnniversaryTableViewCell", for: indexPath) as? AnniversaryCell ?? AnniversaryCell()
        cell.bind(dictValue: Anniversary().AnniversaryModel[indexPath.row + (Anniversary().AnniversaryModel.count - anniversaryFilter.count)], url: Anniversary().AnniversaryUrl[indexPath.row + (Anniversary().AnniversaryModel.count - anniversaryFilter.count)])
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "bgColor")
        return cell
    }
}

// Google AdMob Delegate
//
extension AnniversaryViewController : GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}
