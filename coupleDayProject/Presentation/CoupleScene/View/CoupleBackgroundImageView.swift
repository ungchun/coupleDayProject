//
//  CoupleBackgroundImageView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/29.
//

import UIKit

final class CoupleBackgroundImageView: BaseView {
	
	//MARK: - Views
	
	let backgroundImageView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		self.addSubview(backgroundImageView)
		
		NSLayoutConstraint.activate([
			backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
			backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
		])
	}
	
	override func setupView() { }
}
