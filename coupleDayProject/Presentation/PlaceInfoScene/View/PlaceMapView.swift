//
//  PlaceMapView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/07/03.
//

import UIKit
import MapKit

protocol PlaceMapViewDelegate: AnyObject {
	func didOpenMapAppBtnTap()
}

final class PlaceMapView: BaseView {
	
	//MARK: - Properties
	
	weak var delegate: PlaceMapViewDelegate?
	var datePlace: Place?
	
	//MARK: - Views
	
	private let mapAddressTitle: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "위치"
		label.font = UIFont(name: "GangwonEduAllBold", size: 25)
		return label
	}()
	
	private let mapView: MKMapView = {
		let view = MKMapView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let openMapAppBtn: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.systemGray5.cgColor
		button.titleLabel?.font =  UIFont(name: "GangwonEduAllLight", size: 15)
		button.setTitleColor(
			UserDefaultsSetting.isDarkMode ? .white : .black,
			for: .normal
		)
		button.layer.cornerRadius = 10
		button.setTitle("지도 앱 열기", for: .normal)
		return button
	}()
	
	
	//MARK: - Life Cycle

	override init(frame: CGRect) {
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Functions
	
	override func setupLayout() {
		addSubview(mapAddressTitle)
		addSubview(mapView)
		addSubview(openMapAppBtn)
		
		NSLayoutConstraint.activate([
			mapAddressTitle.topAnchor.constraint(equalTo: self.topAnchor),
			mapAddressTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor)
		])
		
		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: mapAddressTitle.bottomAnchor, constant: 20),
			mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
			mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
			mapView.heightAnchor.constraint(equalToConstant: 200)
		])
		
		NSLayoutConstraint.activate([
			openMapAppBtn.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
			openMapAppBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
			openMapAppBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
			openMapAppBtn.heightAnchor.constraint(equalToConstant: 50)
		])
	}
	
	override func setupView() {
		mapView.delegate = self
		
		openMapAppBtn.addTarget(self, action: #selector(oepnMapAppBtnTap), for: .touchUpInside)
	}
}

extension PlaceMapView {
	@objc func oepnMapAppBtnTap() {
		delegate?.didOpenMapAppBtnTap()
	}
	
	func mapZoomInAnimation() {
		guard let datePlace = datePlace else { return }
		guard let latitude = Double(datePlace.latitude) else { return }
		guard let longitude = Double(datePlace.longitude) else { return }
		let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		mapView.setRegion(region, animated: true)
		let pin = MKPointAnnotation()
		pin.coordinate = coordinate
		pin.title = datePlace.placeName
		mapView.addAnnotation(pin)
	}
}

extension PlaceMapView: MKMapViewDelegate, CLLocationManagerDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
		let reuseId = "pin"
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView // pin 모양 변경
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			if let unwrappingPinView = pinView {
				unwrappingPinView.canShowCallout = true
				unwrappingPinView.rightCalloutAccessoryView = UIButton(type: .infoDark)
			}
		}
		else {
			if let unwrappingPinView = pinView {
				unwrappingPinView.annotation = annotation
			}
		}
		return pinView
	}
}
