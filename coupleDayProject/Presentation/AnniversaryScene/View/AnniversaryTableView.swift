//
//  AnniversaryTableView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/28.
//

import UIKit

final class AnniversaryTableView: UITableView {
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: .zero, style: .plain)
		
		setupLayout()
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension AnniversaryTableView {
	
	//MARK: - Functions
	
	func setupLayout() {
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setupView() {
		self.backgroundColor = UIColor(named: "bgColor")
		
		self.register(
			AnniversaryTableViewCell.self,
			forCellReuseIdentifier: "AnniversaryTableViewCell"
		)
		
		self.delegate = self
		self.dataSource = self
		self.separatorStyle = .none
		
		self.rowHeight = 140
		self.estimatedRowHeight = UITableView.automaticDimension
	}
}

extension AnniversaryTableView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let nowMillisecondDate = Date().millisecondsSince1970
		
		let anniversaryFilter = Anniversary.AnniversaryInfo.filter {dictValue in
			let keyValue = dictValue.keys.first
			if nowMillisecondDate < keyValue?.toDate.millisecondsSince1970 ?? 0 {
				return true
			} else {
				return false
			}
		}
		return anniversaryFilter.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let nowMillisecondDate = Date().millisecondsSince1970
		
		let anniversaryFilter = Anniversary.AnniversaryInfo.filter { dictValue in
			let keyValue = dictValue.keys.first
			if nowMillisecondDate < keyValue?.toDate.millisecondsSince1970 ?? 0 {
				return true
			} else {
				return false
			}
		}
		
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "AnniversaryTableViewCell",
			for: indexPath
		) as? AnniversaryTableViewCell ?? AnniversaryTableViewCell()
		cell.setAnniversaryCellText(
			dictValue: Anniversary.AnniversaryInfo[
				indexPath.row + (Anniversary.AnniversaryInfo.count - anniversaryFilter.count)
			],
			url: Anniversary.AnniversaryImageUrl[
				indexPath.row + (Anniversary.AnniversaryInfo.count - anniversaryFilter.count)
			]
		)
		cell.selectionStyle = .none
		cell.backgroundColor = UIColor(named: "bgColor")
		return cell
	}
}
