//
//  InterfaceController.swift
//  coupleDayWatch WatchKit Extension
//
//  Created by 김성훈 on 2022/07/12.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    var count: Int = 0
    
    @IBOutlet weak var demoImage: WKInterfaceImage!
    @IBOutlet weak var demoLabel: WKInterfaceLabel!
    @IBOutlet weak var group: WKInterfaceGroup!
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        demoLabel.setText("테스트")
        group.setContentInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    

}
