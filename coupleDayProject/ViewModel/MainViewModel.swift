import Combine
import Foundation

final class MainViewModelCombine: ObservableObject {
    
    // MARK: Properties
    //
    private var changeLabelInitCheck = false
    private var appNameDayToggleFlag = false
    private var changeLabelTimer = Timer()
    var receivedCoupleDayData = "너랑나랑"
    
    @Published var appNameLabelValue: String = "너랑나랑"
    
    // MARK: Functions
    //
    init() {
        changeAppNameLabel()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveCoupleDayData(notification:)),
            name: Notification.Name.coupleDay, object: nil
        )
    }
    
    private func changeAppNameLabel() {
        if !changeLabelInitCheck {
            changeLabelTimer = Timer.scheduledTimer(
                timeInterval: 5,
                target: self,
                selector: #selector(updateLabel),
                userInfo: nil,
                repeats: true
            )
            changeLabelInitCheck = true
        }
    }
    
    @objc private func updateLabel() {
        self.appNameLabelValue = appNameDayToggleFlag ? "\(receivedCoupleDayData) days" : "너랑나랑"
        appNameDayToggleFlag.toggle()
    }
    
    @objc private func receiveCoupleDayData(notification: Notification) {
        guard let object = notification.userInfo?["coupleDay"] as? String else { return }
        receivedCoupleDayData = object
    }
}
