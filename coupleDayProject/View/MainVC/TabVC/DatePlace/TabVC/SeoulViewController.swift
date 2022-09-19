import UIKit
import Kingfisher

class SeoulViewController: UIViewController {
    
    // MARK: Properties
    //
    private var mainDatePlaceList = [DatePlaceModel]()
    
    // MARK: Views
    //
    private lazy var datePlaceCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "bgColor")
        return collectionView
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFirebaseData { [weak self] in
            guard let self = self else { return }
            
            // fadeIn Animation
            //
            self.setUpView()
            self.datePlaceCollectionView.alpha = 0
            self.datePlaceCollectionView.fadeIn()
            
            NSLayoutConstraint.activate([
                //                self.datePlaceCollectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
                //                self.datePlaceCollectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            ])
        }
    }
    
    // MARK: Functions
    //
    
    private func setUpView() {
        view.addSubview(self.datePlaceCollectionView)
        datePlaceCollectionView.dataSource = self
        datePlaceCollectionView.delegate = self
        datePlaceCollectionView.register(DatePlaceCollectionViewCell.self, forCellWithReuseIdentifier: DatePlaceCollectionViewCell.reuseIdentifier)
        
        
        datePlaceCollectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    private func loadFirebaseData(completion: @escaping () -> ()) {
        var count = 0
        let localNameText = "seoul"
        FirebaseManager.shared.firestore.collection("\(localNameText)").getDocuments { [self] (querySnapshot, error) in
            guard error == nil else { return }
            for document in querySnapshot!.documents {
                print("loadFirebaseData")
                var datePlaceValue = DatePlaceModel()
                
                datePlaceValue.modifyStateCheck = document.data()["modifyState"] as! Bool
                if datePlaceValue.modifyStateCheck == true { continue }
                
                datePlaceValue.placeName = document.documentID
                datePlaceValue.address = document.data()["address"] as! String
                datePlaceValue.shortAddress = document.data()["shortAddress"] as! String
                datePlaceValue.introduce = document.data()["introduce"] as! Array<String>
                datePlaceValue.imageUrl = document.data()["imageUrl"] as! Array<String>
                datePlaceValue.latitude = document.data()["latitude"] as! String
                datePlaceValue.longitude = document.data()["longitude"] as! String
                
                mainDatePlaceList.append(datePlaceValue)
                count += 1
                
                DispatchQueue.global().async { [weak self] in
                    guard let self = self else { return }
                    self.downloadImageAndCache(with: datePlaceValue.imageUrl.first!)
                }
                
                if count == 5 { break }
            }
            mainDatePlaceList.shuffle()
            completion()
        }
    }
    private func downloadImageAndCache(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
            case .success(let value):
                if value.image != nil { //캐시가 존재하는 경우
                    
                } else { //캐시가 존재하지 않는 경우
                    let resource = ImageResource(downloadURL: url)
                    KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            print("success value.image \(value.image)")
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SeoulViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePlaceCollectionViewCell.reuseIdentifier, for: indexPath)
        //        if self.mainDatePlaceList.count > indexPath.item {
        //            if let cell = cell as? DatePlaceCollectionViewCell {
        //                cell.datePlaceImageView.image = nil
        //                cell.datePlaceModel = mainDatePlaceList[indexPath.item]
        //            }
        //        }
        if let cell = cell as? DatePlaceCollectionViewCell {
            cell.datePlaceImageView.image = nil
            cell.datePlaceModel = mainDatePlaceList[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailDatePlaceViewController = DetailDatePlaceViewController()
        detailDatePlaceViewController.datePlace = mainDatePlaceList[indexPath.item]
        self.navigationController?.pushViewController(detailDatePlaceViewController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 60
        let collectionViewSize = datePlaceCollectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2+200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}
