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
	
	lazy var datePlaceTitle: UILabel = {
		var label = UILabel()
		label.font = UIFont(name: "GangwonEduAllBold", size: CommonSize.coupleTextBigSize)
		return label
	}()
	
	lazy var datePlaceCollectionView: UICollectionView = {
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
	
	lazy var datePlaceStackView: UIStackView = {
		var stackView = UIStackView(arrangedSubviews: [datePlaceTitle, datePlaceCollectionView])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .vertical
		stackView.spacing = 0
		stackView.backgroundColor = UIColor(named: "bgColor")
		return stackView
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		self.addSubview(datePlaceStackView)
		
		NSLayoutConstraint.activate([
			datePlaceStackView.topAnchor.constraint(equalTo: self.topAnchor),
			datePlaceStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			datePlaceStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			datePlaceStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		])
	}
	
	override func setupView() {
		datePlaceCollectionView.dataSource = self
		datePlaceCollectionView.delegate = self
		datePlaceCollectionView.register(
			TodayDatePlaceCollectionViewCell.self,
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
			if let cell = cell as? TodayDatePlaceCollectionViewCell {
				cell.datePlaceImageView.image = nil
				cell.placeModel = mainDatePlaceList[indexPath.item]
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let detailDatePlaceViewController = DetailDatePlaceViewController()
		detailDatePlaceViewController.datePlace = mainDatePlaceList[indexPath.item]
		if let viewController = window?.rootViewController as? UINavigationController {
			viewController.pushViewController(detailDatePlaceViewController, animated: true)
		}
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		return CGSize(
			width: CommonSize.coupleCellImageSize + 10,
			height: datePlaceCollectionView.frame.height
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
