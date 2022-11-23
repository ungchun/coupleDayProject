import UIKit

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

        imageUrlArray.forEach { value in
            DispatchQueue.global().async {
                CacheImageManger().downloadImageAndCache(urlString: value)
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
    
    private func visibleCellIndexPath() -> IndexPath {
        return carouselCollectionView.indexPathsForVisibleItems[0]
    }
    
    @objc func timerCallBack() {
        var item = visibleCellIndexPath().item
        
        guard let imageUrlArray = imageUrlArray else { return }
        if item == imageUrlArray.count * 3 - 1 {
            carouselCollectionView.scrollToItem(
                at: IndexPath(item: imageUrlArray.count * 2 - 1, section: 0),
                at: .centeredHorizontally, animated: false
            )
            item = imageUrlArray.count * 2 - 1
        }
        
        item += 1
        
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
extension DatePlaceCarouselView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        invalidateTimer()
        activateTimer()
        
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
