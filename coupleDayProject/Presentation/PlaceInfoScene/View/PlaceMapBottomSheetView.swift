//
//  PlaceMapBottomSheetView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/07/03.
//

import UIKit

protocol PlaceMapBottomSheetViewDelegate: AnyObject {
	func didDimmedViewTapped()
	func failOpenkakaoMaps()
	func failOpenGoogleMaps()
}

final class PlaceMapBottomSheetView: BaseView {
	
	//MARK: - Properties
	
	weak var delegate: PlaceMapBottomSheetViewDelegate?
	var datePlace: Place?
	var bottomSheetViewTopConstraint: NSLayoutConstraint!
	
	//MARK: - Views
	
	let dimmedBackView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.alpha = 0.0
		return view
	}()
	
	private let bottomSheetView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(named: "bgColor")
		view.layer.cornerRadius = 27
		view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		view.clipsToBounds = true
		return view
	}()
	
	private let dismissIndicatorView: UIView = {
		let view = UIView()
		view.backgroundColor = .systemGray2
		view.layer.cornerRadius = 3
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let openMapsTitleText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllBold", size: 25)
		label.text = "지도 앱 열기"
		return label
	}()
	
	private let googleMapsIcon: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.image = UIImage(named: "googleMapSymbol")
		view.layer.cornerRadius = 25
		view.clipsToBounds = true
		view.contentMode = .scaleAspectFill
		return view
	}()
	
	private let googleMapsText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: 18)
		label.text = "구글 맵스"
		return label
	}()
	
	private lazy var googleMapsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.spacing = 20
		stackView.isUserInteractionEnabled = true
		return stackView
	}()
	
	private let kakaoMapsIcon: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.image = UIImage(named: "kakaoMapSymbol")
		view.layer.cornerRadius = 25
		view.clipsToBounds = true
		view.contentMode = .scaleAspectFill
		return view
	}()
	
	private let kakaoMapsText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: 18)
		label.text = "카카오맵"
		return label
	}()
	
	private lazy var kakaoMapsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.spacing = 20
		stackView.isUserInteractionEnabled = true
		return stackView
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		addSubview(dimmedBackView)
		addSubview(bottomSheetView)
		addSubview(dismissIndicatorView)
		
		kakaoMapsStackView.addArrangedSubview(kakaoMapsIcon)
		kakaoMapsStackView.addArrangedSubview(kakaoMapsText)
		
		googleMapsStackView.addArrangedSubview(googleMapsIcon)
		googleMapsStackView.addArrangedSubview(googleMapsText)
		
		bottomSheetView.addSubview(openMapsTitleText)
		bottomSheetView.addSubview(googleMapsStackView)
		bottomSheetView.addSubview(kakaoMapsStackView)
		
		NSLayoutConstraint.activate([
			dimmedBackView.topAnchor.constraint(equalTo: self.topAnchor),
			dimmedBackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			dimmedBackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			dimmedBackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
		
		bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.size.height)
		NSLayoutConstraint.activate([
			bottomSheetView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
			bottomSheetView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
			bottomSheetView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			bottomSheetViewTopConstraint
		])
		
		NSLayoutConstraint.activate([
			dismissIndicatorView.widthAnchor.constraint(equalToConstant: 102),
			dismissIndicatorView.heightAnchor.constraint(equalToConstant: 7),
			dismissIndicatorView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 12),
			dismissIndicatorView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
		])
		
		NSLayoutConstraint.activate([
			openMapsTitleText.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 50),
			openMapsTitleText.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 40),
			openMapsTitleText.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -40)
		])
		
		NSLayoutConstraint.activate([
			googleMapsIcon.widthAnchor.constraint(equalToConstant: 50),
			googleMapsIcon.heightAnchor.constraint(equalToConstant: 50),
		])
		
		NSLayoutConstraint.activate([
			kakaoMapsIcon.widthAnchor.constraint(equalToConstant: 50),
			kakaoMapsIcon.heightAnchor.constraint(equalToConstant: 50),
		])
		
		NSLayoutConstraint.activate([
			googleMapsStackView.topAnchor.constraint(equalTo: openMapsTitleText.bottomAnchor, constant: 30),
			googleMapsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
			googleMapsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
		])
		
		NSLayoutConstraint.activate([
			kakaoMapsStackView.topAnchor.constraint(equalTo: googleMapsStackView.bottomAnchor, constant: 10),
			kakaoMapsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
			kakaoMapsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
		])
	}
	
	override func setupView() {
		let dimmedTap = UITapGestureRecognizer(
			target: self,
			action: #selector(dimmedViewTapped(_:))
		)
		dimmedBackView.addGestureRecognizer(dimmedTap)
		
		let googleMapsTapGesture = UITapGestureRecognizer(
			target: self,
			action: #selector(openGoogleMaps)
		)
		googleMapsStackView.addGestureRecognizer(googleMapsTapGesture)
		
		let kakaoMapsTapGesture = UITapGestureRecognizer(
			target: self,
			action: #selector(openkakaoMaps)
		)
		kakaoMapsStackView.addGestureRecognizer(kakaoMapsTapGesture)
	}
}

private extension PlaceMapBottomSheetView {
	@objc func openGoogleMaps() {
		guard let datePlace else { return }
		guard let latitude = Double(datePlace.latitude) else { return }
		guard let longitude = Double(datePlace.longitude) else { return }
		let url = URL(string: "comgooglemaps://?center=\(latitude),\(longitude)&zoom=17&mapmode=standard")
		
		if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!){
			UIApplication.shared.open(url!, options: [:], completionHandler: nil)
		} else {
			delegate?.failOpenGoogleMaps()
		}
	}
	
	@objc func openkakaoMaps() {
		guard let datePlace else { return }
		guard let latitude = Double(datePlace.latitude) else { return }
		guard let longitude = Double(datePlace.longitude) else { return }
		let url = URL(string: "kakaomap://look?p=\(latitude),\(longitude)")
		if UIApplication.shared.canOpenURL(URL(string:"kakaomap://")!){
			UIApplication.shared.open(url!, options: [:], completionHandler: nil)
		} else {
			delegate?.failOpenkakaoMaps()
		}
	}
	
	@objc func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
		delegate?.didDimmedViewTapped()
	}
}
