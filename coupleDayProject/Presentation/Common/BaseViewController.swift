//
//  BaseViewController.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/26.
//

import UIKit

class BaseViewController: UIViewController {
	
	override func viewDidLoad() {
		setupLayout()
		setupView()
	}
	
	func setupLayout() { }
	
	func setupView() { }
	
	func setupBackButton() {
		self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor
		UIBarButtonItem.appearance().setTitleTextAttributes([
			NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any
		], for: .normal)
		self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
		self.view.backgroundColor = UIColor(named: "bgColor")
	}
}
