//
//  StoryTableView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/29.
//

import UIKit

final class StoryTableView: UITableView {
	
	//MARK: - Properties
	
	var coupleTabViewModel: CoupleTabViewModel?
	
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

private extension StoryTableView {
	
	//MARK: - Functions
	
	func setupLayout() { }
	
	func setupView() {
		translatesAutoresizingMaskIntoConstraints = false
		showsVerticalScrollIndicator = false
		
		backgroundColor = UIColor(named: "bgColor")
		
		register(
			StoryTableViewCell.self,
			forCellReuseIdentifier: "CodingCustomTableViewCell"
		)
		delegate = self
		dataSource = self
		separatorStyle = .none
		rowHeight = 80
		estimatedRowHeight = UITableView.automaticDimension
	}
}

extension StoryTableView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return StoryStandardDay().dayValues.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "CodingCustomTableViewCell",
			for: indexPath
		) as? StoryTableViewCell ?? StoryTableViewCell()
		cell.setStoryCellText(
			index: StoryStandardDay().dayValues[indexPath.row],
			beginCoupleDay: (coupleTabViewModel?.output.beginCoupleDayOutput.value)!
		)
		cell.selectionStyle = .none
		cell.backgroundColor = UIColor(named: "bgColor")
		return cell
	}
}
