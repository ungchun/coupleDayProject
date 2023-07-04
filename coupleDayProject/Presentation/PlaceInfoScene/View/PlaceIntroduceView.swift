//
//  PlaceIntroduceView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/07/04.
//

import UIKit

final class PlaceIntroduceView: BaseView {

	//MARK: - Views
	
	let introduceTitle: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllBold", size: 25)
		return label
	}()
	
	let introduceContent: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: 15)
		label.numberOfLines = 0
		return label
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		addSubview(introduceTitle)
		addSubview(introduceContent)
		
		NSLayoutConstraint.activate([
			introduceTitle.topAnchor.constraint(equalTo: self.topAnchor),
			introduceTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			introduceTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
		])
		
		NSLayoutConstraint.activate([
			introduceContent.topAnchor.constraint(equalTo: introduceTitle.bottomAnchor, constant: 10),
			introduceContent.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			introduceContent.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			introduceContent.bottomAnchor.constraint(equalTo: self.bottomAnchor),
		])
	}
	
	override func setupView() { }
}
