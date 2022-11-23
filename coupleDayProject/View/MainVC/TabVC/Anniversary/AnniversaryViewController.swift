import UIKit

import GoogleMobileAds

final class AnniversaryViewController: UIViewController {
    
    // MARK: Properties
    //
    weak var coordinator: AnniversaryViewCoordinator?
    
    // MARK: Views
    //
    private let anniversaryTitleLabel: UILabel = {
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
    private let topContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    private let allContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.anniversaryTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishAnniversaryView()
    }
    
    // MARK: Functions
    //
    private func setUpView() {
        view.backgroundColor = UIColor(named: "bgColor")
        
        anniversaryTableView.backgroundColor = UIColor(named: "bgColor")
        anniversaryTableView.register(
            AnniversaryTableViewCell.self,
            forCellReuseIdentifier: "AnniversaryTableViewCell"
        )
        anniversaryTableView.delegate = self
        anniversaryTableView.dataSource = self
        anniversaryTableView.separatorStyle = .none
        
        view.addSubview(topContentStackView)
        topContentStackView.addArrangedSubview(anniversaryTitleLabel)
        
        view.addSubview(allContentStackView)
        allContentStackView.addArrangedSubview(topContentStackView)
        allContentStackView.addArrangedSubview(divider)
        allContentStackView.addArrangedSubview(anniversaryTableView)
        
        let tapcloseBtn = UITapGestureRecognizer(target: self, action: #selector(tapClose))
        
        topContentStackView.isUserInteractionEnabled = true
        topContentStackView.addGestureRecognizer(tapcloseBtn)
        
        NSLayoutConstraint.activate([
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            topContentStackView.heightAnchor.constraint(equalToConstant: 50),
            
            allContentStackView.topAnchor.constraint(equalTo: self.view.topAnchor ,constant: 5),
            allContentStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            allContentStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            allContentStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        anniversaryTableView.rowHeight = 140
        anniversaryTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    @objc func tapClose() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Extension
//
extension AnniversaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nowMillisecondDate = Date().millisecondsSince1970
        let anniversaryFilter = AnniversaryModel.AnniversaryInfo.filter {dictValue in
            let keyValue = dictValue.keys.first
            if nowMillisecondDate < (keyValue?.toDate.millisecondsSince1970)! {
                return true
            } else {
                return false
            }
        }
        return anniversaryFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nowMillisecondDate = Date().millisecondsSince1970
        let anniversaryFilter = AnniversaryModel.AnniversaryInfo.filter { dictValue in
            let keyValue = dictValue.keys.first
            if nowMillisecondDate < (keyValue?.toDate.millisecondsSince1970)! {
                return true
            } else {
                return false
            }
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "AnniversaryTableViewCell",
            for: indexPath
        ) as? AnniversaryTableViewCell ?? AnniversaryTableViewCell()
        cell.setAnniversaryCellText(
            dictValue: AnniversaryModel.AnniversaryInfo[
                indexPath.row + (AnniversaryModel.AnniversaryInfo.count - anniversaryFilter.count)
            ],
            url: AnniversaryModel.AnniversaryImageUrl[
                indexPath.row + (AnniversaryModel.AnniversaryInfo.count - anniversaryFilter.count)
            ]
        )
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "bgColor")
        return cell
    }
}

extension AnniversaryViewController : GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
}
