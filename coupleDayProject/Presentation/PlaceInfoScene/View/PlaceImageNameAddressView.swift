//
//  PlaceInformationView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/07/03.
//

import UIKit

final class PlaceImageNameAddressView: BaseView {
	
	//MARK: - Views
	
	let datePlaceImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	let datePlaceName: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllBold", size: 25)
		return label
	}()
	
	let datePlaceAddress: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: 15)
		label.textColor = .gray
		return label
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		addSubview(datePlaceImageView)
		addSubview(datePlaceName)
		addSubview(datePlaceAddress)
		
		NSLayoutConstraint.activate([
			datePlaceImageView.topAnchor.constraint(equalTo: self.topAnchor),
			datePlaceImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			datePlaceImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			datePlaceImageView.heightAnchor.constraint(equalToConstant: 400)
		])
		
		NSLayoutConstraint.activate([
			datePlaceName.topAnchor.constraint(equalTo: datePlaceImageView.bottomAnchor, constant: 30),
			datePlaceName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
		])
		
		NSLayoutConstraint.activate([
			datePlaceAddress.topAnchor.constraint(equalTo: datePlaceName.bottomAnchor, constant: 10),
			datePlaceAddress.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
		])
	}
	
	override func setupView() { }
}
