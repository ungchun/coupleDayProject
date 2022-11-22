import ClockKit
import Foundation
import WatchKit
import WatchConnectivity

class DayInfo {
    static let shared = DayInfo()
    
    var days: String?
    private init() { }
    
}

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var demoImage: WKInterfaceImage!
    @IBOutlet weak var demoLabel: WKInterfaceLabel!
    @IBOutlet weak var topTitle: WKInterfaceLabel!
    @IBOutlet weak var todayLabel: WKInterfaceLabel!
    @IBOutlet weak var group: WKInterfaceGroup!
    
    var count: Int = 0
    let session = WCSession.default
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let data = userInfo["imageData"] as? Data {
            DispatchQueue.main.async {
                self.demoImage.setImage(UIImage(data: data))
            }
        } else { }
    }
    
    override init() {
        super.init()
    }
    
    override func awake(withContext context: Any?) {
        assert(WCSession.isSupported(), "watch")
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    override func willActivate() {
        
        group.setContentInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        let receiveData = WCSession.default.receivedApplicationContext
        if receiveData.isEmpty == false {
            DispatchQueue.main.async {
                if let data = receiveData.values.first as? String {
                    let nowDayDataString = Date().toString
                    let nowDayDataDate = nowDayDataString.toDate
                    let minus = nowDayDataDate.millisecondsSince1970-Int64(data)!
                    let value = String(describing: minus / 86400000)
                    DayInfo.shared.days = data
                    DispatchQueue.main.async {
                        self.demoLabel.setText("\(value) days")
                    }

                    let complicationServer = CLKComplicationServer.sharedInstance()
                    guard let activeComplications = complicationServer.activeComplications else {
                        return
                    }
                    for complication in activeComplications {
                        complicationServer.reloadTimeline(for: complication)
                    }
                } else {
                    self.demoLabel.setText("days")
                }
            }
        }
        
        self.topTitle.setText("우리 오늘")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        self.todayLabel.setText(dateFormatter.string(from: Date()))
    }
    
    override func didDeactivate() { }
    
}

extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    // date -> return string yyyy-MM-dd
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    // string yyyy-MM-dd -> return date
    //
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)!
    }
}
