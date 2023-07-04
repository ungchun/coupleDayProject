//
//  CoupleTodayPlaceView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/29.
//

import UIKit

final class CoupleTodayPlaceView: BaseView {
	
	//MARK: - Properties
	
	var mainDatePlaceList = [Place]()
	
	//MARK: - Views
	
	let todayPlaceText: UILabel = {
		var label = UILabel()
		label.font = UIFont(name: "GangwonEduAllBold", size: CommonSize.coupleTextBigSize)
		return label
	}()
	
	lazy var todayPlaceCollectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.minimumLineSpacing = 0
		flowLayout.minimumInteritemSpacing = 0
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.backgroundColor = UIColor(named: "bgColor")
		return collectionView
	}()
	
	lazy var contentView: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [todayPlaceText, todayPlaceCollectionView])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .vertical
		stackView.spacing = 0
		stackView.backgroundColor = UIColor(named: "bgColor")
		return stackView
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		self.addSubview(contentView)
		
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: self.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		])
	}
	
	override func setupView() {
		todayPlaceCollectionView.dataSource = self
		todayPlaceCollectionView.delegate = self
		todayPlaceCollectionView.register(
			TodayPlaceCollectionViewCell.self,
			forCellWithReuseIdentifier: "cell"
		)
	}
}


extension CoupleTodayPlaceView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		return 5
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		if self.mainDatePlaceList.count > indexPath.item {
			if let cell = cell as? TodayPlaceCollectionViewCell {
				cell.datePlaceImageView.image = nil
				cell.placeModel = mainDatePlaceList[indexPath.item]
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let placeInfoViewController = PlaceInfoViewController()
		placeInfoViewController.datePlace = mainDatePlaceList[indexPath.item]
		if let viewController = window?.rootViewController as? UINavigationController {
			viewController.pushViewController(placeInfoViewController, animated: true)
		}
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		return CGSize(
			width: CommonSize.coupleCellImageSize + 10,
			height: todayPlaceCollectionView.frame.height
		)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
}

extension CoupleTodayPlaceView: UICollectionViewDelegate {}
