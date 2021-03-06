import Foundation
import Combine

// dataBinding Combineb 버전
//
class ContainerViewModelCombine: ObservableObject {
    
    private var changeLabelCheck = false // 타이머 시작은 딱 한번만 해야함 -> 체크하는 변수
    private var labelState = false // 앱 이름 <> 연애 날짜 상태확인해주는 변수
    private var changeLabelTimer = Timer() // 자동으로 함수 실행하기 위한 타이머
    
    @Published var appNameLabelValue: String = "너랑나랑"
    
    init() {
        changeAppNameLabel()
    }
    
    // MARK: func
    //
    fileprivate func changeAppNameLabel() {
        if !changeLabelCheck {
            
            // 5초마다 updateLabel() 실행
            //
            changeLabelTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
            changeLabelCheck = true
        }
    }
    
    // MARK: objc
    //
    @objc
    fileprivate func updateLabel() {
        self.appNameLabelValue = labelState ? "\(CoupleTabViewModel.publicBeginCoupleDay) days" : "너랑나랑"
        labelState.toggle()
    }
}

// dataBinding Observables 버전
//
class ContainerViewModel {
    
    // 3) 호출되면, 2번에서 받은 값을 전달한다.
    //
    var onUpdatedLabel: () -> Void = {}
    
    private var labelState = false // 앱 이름 <> 연애 날짜 상태확인해주는 변수
    private var changeLabelCheck = false // 타이머 시작은 딱 한번만 해야함 -> 체크하는 변수
    private var changeLabelTimer = Timer() // 자동으로 함수 실행하기 위한 타이머
    
    // 2) 값이 set되면, didSet이 실행되고 값을 참조하는 친구에게 해당 값을 전달한다,
    //
    var appNameLabelValue: String = "너랑나랑" {
        didSet {
            onUpdatedLabel() // appNameLabelValue 변경되면 onUpdated 실행
        }
    }
    
    // MARK: init
    //
    // 1) 초기화함수를 통해서 값을 입력받고, 그 값을 label에 세팅
    //
    init() {
        changeAppNameLabel()
    }
    
    // MARK: func
    //
    fileprivate func changeAppNameLabel() {
        if !changeLabelCheck {
            
            // 5초마다 updateLabel() 실행
            //
            changeLabelTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
            changeLabelCheck = true
        }
    }
    
    // MARK: objc
    //
    @objc
    fileprivate func updateLabel() {
        self.appNameLabelValue = labelState ? "\(CoupleTabViewModel.publicBeginCoupleDay) days" : "너랑나랑"
        labelState.toggle()
    }
}

// MARK: ViewModel 좋은 예제
//
class Observable<T> {
    // 3) 호출되면, 2번에서 받은 값을 전달한다.
    //
    private var listener: ((T) -> Void)?
    
    // 2) 값이 set되면, listener에 해당 값을 전달한다,
    //
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    // 1) 초기화함수를 통해서 값을 입력받고, 그 값을 "value"에 저장한다.
    //
    init(_ value: T) {
        self.value = value
    }
    
    // 4) 다른 곳에서 bind라는 메소드를 호출하게 되면,
    // value에 저장했떤 값을 전달해주고,
    // 전달받은 "closure" 표현식을 listener에 할당한다.
    //
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
