//
//  InterfaceController.swift
//  coupleDayWatch WatchKit Extension
//
//  Created by 김성훈 on 2022/07/12.
//

import WatchKit
import Foundation
import WatchConnectivity

enum Command: String {
    case updateAppContext = "UpdateAppContext"
    case sendMessage = "SendMessage"
    case sendMessageData = "SendMessageData"
    case transferUserInfo = "TransferUserInfo"
    case transferFile = "TransferFile"
    case transferCurrentComplicationUserInfo = "TransferComplicationUserInfo"
}


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    private var command: Command!
    
    @IBOutlet weak var demoImage: WKInterfaceImage!
    @IBOutlet weak var demoLabel: WKInterfaceLabel!
    @IBOutlet weak var topTitle: WKInterfaceLabel!
    @IBOutlet weak var todayLabel: WKInterfaceLabel!
    @IBOutlet weak var group: WKInterfaceGroup!
    
    var count: Int = 0
    let session = WCSession.default
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let data = userInfo["dayData"] as? String {
            DispatchQueue.main.async {
                self.demoLabel.setText("\(data) days")
            }
        } else {
            self.demoLabel.setText("sibal")
        }
    }
    
    override init() {
        super.init()
        assert(WCSession.isSupported(), "watch")
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        //        session.delegate = self
        //        session.activate()
    }
    
    override func willActivate() {
        group.setContentInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        self.topTitle.setText("우리 오늘")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        self.todayLabel.setText(dateFormatter.string(from: Date.now))
        
//        return dateFormatter.string(from: self)
        
        // updateApplicationContext
        //
        let timedColor = WCSession.default.receivedApplicationContext
        if timedColor.isEmpty == false {
            DispatchQueue.main.async {
                self.demoImage.setImage(UIImage(data: timedColor.values.first as! Data))
            }
        }
        
        //        let test = WCSession.default.outstandingUserInfoTransfers
        //        self.demoLabel.setText("sunghun \(test)")
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
}
