import UIKit
import Kingfisher

class DatePlaceCarouselView: UIView {
    
    // MARK: Properties
    //
    var progress: Progress?
    var timer: Timer?
    var imageUrlArray: Array<String>?
    
    // MARK: Views
    //
    var carouselCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    private lazy var carouselProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .white
        return progressView
    }()
    
    // MARK: Life Cycle
    //
    required init(imageUrlArray: Array<String>){
        super.init(frame: CGRect.zero)
        self.imageUrlArray = imageUrlArray
        self.imageUrlArray!.shuffle()
        
        // 그냥 carousel 페이지 하나씩 넘어갈 때 마다 다운해도 되는데, 처음 들어가면 페이지 넘어갈 때 마다 다운, 캐시처리하는 indicator 화면 봐야함
        // downloadImageAndCache -> imageUrlArray 하나씩 돌면서 url 캐시에 있나 없나 확인해서 없으면 미리 다운
        // 처음 들어가더라도 이 친구 덕분에 캐시처리가 모두 완료된 상태라 indicator 볼 필요없음
        //
        imageUrlArray.forEach { value in
            DispatchQueue.global().async { [weak self] in
                self?.downloadImageAndCache(with: value)
            }
        }
        
        self.addSubview(carouselCollectionView)
        self.addSubview(carouselProgressView)
        
        carouselCollectionView.register(
            CarouselCollectionViewCell.self,
            forCellWithReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier
        )
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        
        carouselCollectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(0)
        }
        carouselProgressView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo((UIScreen.main.bounds.size.width - 40) * 0.6)
            make.bottom.equalTo(carouselCollectionView.snp.bottom).offset(-20)
        }
        
        configureProgressView()
        activateTimer()
        
        let segmentSize = self.imageUrlArray!.count
        carouselCollectionView.scrollToItem(
            at: IndexPath(item: segmentSize, section: 0),
            at: .centeredHorizontally, animated: false
        )
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    //
    private func downloadImageAndCache(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
            case .success(let value):
                if value.image != nil { //캐시가 존재하는 경우
                } else { //캐시가 존재하지 않는 경우
                    let resource = ImageResource(downloadURL: url)
                    KingfisherManager.shared.retrieveImage(
                        with: resource,
                        options: nil,
                        progressBlock: nil
                    ) { result in
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
    
    private func configureProgressView() {
        guard let imageUrlArray = imageUrlArray else { return }
        carouselProgressView.progress = 0.0
        progress = Progress(totalUnitCount: Int64(imageUrlArray.count))
        progress?.completedUnitCount = 1
        carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
    }
    
    func invalidateTimer() {
        timer?.invalidate()
    }
    
    private func activateTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 5,
            target: self,
            selector: #selector(timerCallBack),
            userInfo: nil,
            repeats: true
        )
    }
    
    // 현재 보이는 content의 IndexPath
    //
    private func visibleCellIndexPath() -> IndexPath {
        return carouselCollectionView.indexPathsForVisibleItems[0]
    }
    
    // 시간지나면 배너 움직이는 매서드
    //
    @objc func timerCallBack() {
        var item = visibleCellIndexPath().item
        
        // 제일 끝으로 갔을 때 다시 중간으로 이동시키는 코드
        //
        guard let imageUrlArray = imageUrlArray else { return }
        if item == imageUrlArray.count * 3 - 1 {
            carouselCollectionView.scrollToItem(
                at: IndexPath(item: imageUrlArray.count * 2 - 1, section: 0),
                at: .centeredHorizontally, animated: false
            )
            item = imageUrlArray.count * 2 - 1
        }
        
        item += 1
        
        // 배너형식으로 움직이면서 custome cell 사용하려면 이렇게 안하면 scrollToItem 이거 이상하게 돌아감..
        //
        carouselCollectionView.delegate = self
        carouselCollectionView.reloadData()
        carouselCollectionView.layoutIfNeeded()
        
        carouselCollectionView.scrollToItem(
            at: IndexPath(item: item, section: 0),
            at: .centeredHorizontally, animated: true
        )
        
        let unitCount: Int = item % imageUrlArray.count + 1
        progress?.completedUnitCount = Int64(unitCount)
        carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
    }
}

// MARK: extension
//
// 맨 처음과 끝에서 드래그하면 그 다음 셀이 보인다 -> 시작이 0이 아니다.
// cell list를 3개를 이어붙여서 시작과 동시에 중간으로 오게 한다.
//
extension DatePlaceCarouselView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        invalidateTimer()
        activateTimer()
        
        // 제일 처음 또는 제일 끝으로 갔을 때 다시 중앙으로 이동시키는 코드
        //
        guard let imageUrlArray = imageUrlArray else { return }
        var item = visibleCellIndexPath().item
        if item == imageUrlArray.count * 3 - 1 {
            item = imageUrlArray.count * 2 - 1
        } else if item == 1 {
            item = imageUrlArray.count + 1
        }
        
        carouselCollectionView.scrollToItem(
            at: IndexPath(item: item, section: 0),
            at: .centeredHorizontally, animated: false
        )
        
        let unitCount: Int = item % imageUrlArray.count + 1
        progress?.completedUnitCount = Int64(unitCount)
        carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
    }
}
extension DatePlaceCarouselView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let imageUrlArray = imageUrlArray else { return 0 }
        return imageUrlArray.count * 3
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let imageUrlString = imageUrlArray![indexPath.item % imageUrlArray!.count]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! CarouselCollectionViewCell
        cell.imageView.setImage(with: imageUrlString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}
extension DatePlaceCarouselView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: carouselCollectionView.frame.width,
            height: carouselCollectionView.frame.height
        )
    }
}
