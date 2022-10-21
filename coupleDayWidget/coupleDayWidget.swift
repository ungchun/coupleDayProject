import WidgetKit
import SwiftUI
import UIKit
import RealmSwift

// StaticConfiguration 으로 만듬 -> 사용자가 구성할 필요 없이 보기만하는 구성
//
struct coupleDayEntry: TimelineEntry {
    var date: Date // date 필수로 요구
    let size: CGSize // widget view size
}

// provider : 위젯을 새로고침할 타임라인을 결정하는 객체
//
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> coupleDayEntry {
        coupleDayEntry(date: Date(), size: context.displaySize)
    }
    
    // WidgetKit은 위젯을 추가할 때와 같이 일시적인 상황에서 위젯을 표시하기 위해서 Snapshot 요청
    //
    func getSnapshot(in context: Context, completion: @escaping (coupleDayEntry) -> ()) {
        let entry = coupleDayEntry(date: Date(), size: context.displaySize)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        // date 라는 뷰 업데이트해야하는 시간을 넘겨주면 그 시간이 되면 위젯은 알아서 뷰를 업데이트한다.
        // 0...10 + byAdding: .minute -> 10분마다 업데이트
        // 0...10 + byAdding: .hour -> 10시간마다 업데이트
        //
        var entries: [coupleDayEntry] = []
        let currentDate = Date()
        for minOffset in 0...10 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minOffset, to: currentDate)!
            let entry = coupleDayEntry(date: entryDate, size: context.displaySize)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// view
//
struct coupleDayWidgetEntryView : View {
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    var entry: Provider.Entry
    
    var body: some View {
        
        if #available(iOSApplicationExtension 16.0, *) {
            switch widgetFamily {
            case .systemSmall:
                ZStack {
                    VStack {
                        Image(uiImage: UIImage(systemName: "heart.fill")!)
                            .renderingMode(.template)
                            .foregroundColor(.appMainColor)
                        Text("\(RealmManager.shared.getBeginCoupleDay()) days")
                            .font(.custom("GangwonEduAllLight", size: 25))
                            .foregroundColor(.white)
                    }
                }
                .background(
                    Image(uiImage: UIImage(data: RealmManager.shared.getMainBackgroundImage())!)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: entry.size.width, height: entry.size.height)
                        .scaledToFill()
                )
            case .systemMedium:
                ZStack {
                    VStack {
                        Image(uiImage: UIImage(systemName: "heart.fill")!)
                            .renderingMode(.template)
                            .foregroundColor(.appMainColor)
                        Text("\(RealmManager.shared.getBeginCoupleDay()) days")
                            .font(.custom("GangwonEduAllLight", size: 30))
                            .foregroundColor(.white)
                    }
                }
                .background(
                    Image(uiImage: UIImage(data: RealmManager.shared.getMainBackgroundImage())!)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: entry.size.width, height: entry.size.height)
                        .scaledToFill()
                )
            case .accessoryCircular:
                ZStack{
                    AccessoryWidgetBackground()
                    VStack(spacing: 0) {
                        Image(uiImage: UIImage(systemName: "heart.fill")!)
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.appMainColor)
                            .frame(width: 10.0, height: 10.0)
                            .scaledToFit()
                        Text("\(RealmManager.shared.getBeginCoupleDay())")
                            .font(.custom("GangwonEduAllBold", size: 24))
                            .foregroundColor(.white)
                        Text("days")
                            .font(.custom("GangwonEduAllLight", size: 12))
                            .foregroundColor(.white)
                    }
                }
            case .accessoryRectangular:
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("\(RealmManager.shared.getBeginCoupleDay())")
                            .font(.custom("GangwonEduAllBold", size: 24))
                            .foregroundColor(.white)
                        Text(" days")
                            .font(.custom("GangwonEduAllLight", size: 14))
                            .foregroundColor(.white)
                    }
                    Text("너랑나랑")
                        .font(.custom("GangwonEduAllLight", size: 12))
                        .foregroundColor(.white)
                    Text("함께 한 시간")
                        .font(.custom("GangwonEduAllLight", size: 12))
                        .foregroundColor(.white)
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            default:
                Text("unknown")
            }
        } else {
            switch widgetFamily {
            case .systemSmall:
                ZStack {
                    VStack {
                        Image(uiImage: UIImage(systemName: "heart.fill")!)
                            .renderingMode(.template)
                            .foregroundColor(.appMainColor)
                        Text("\(RealmManager.shared.getBeginCoupleDay()) days")
                            .font(.custom("GangwonEduAllLight", size: 25))
                            .foregroundColor(.white)
                    }
                }
                .background(
                    Image(uiImage: UIImage(data: RealmManager.shared.getMainBackgroundImage())!)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: entry.size.width, height: entry.size.height)
                        .scaledToFill()
                )
            case .systemMedium:
                ZStack {
                    VStack {
                        Image(uiImage: UIImage(systemName: "heart.fill")!)
                            .renderingMode(.template)
                            .foregroundColor(.appMainColor)
                        Text("\(RealmManager.shared.getBeginCoupleDay()) days")
                            .font(.custom("GangwonEduAllLight", size: 30))
                            .foregroundColor(.white)
                    }
                }
                .background(
                    Image(uiImage: UIImage(data: RealmManager.shared.getMainBackgroundImage())!)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: entry.size.width, height: entry.size.height)
                        .scaledToFill()
                )
            default:
                Text("unknown")
            }
        }
    }
}

@main
struct coupleDayWidget: Widget {
    // kind : 모든 Widget에는 고유한 문자열이 존재, 이 문자열을 가지고 위젯을 식별 가능
    //
    let kind: String = "ungchun.coupleDayProject"
    
    private let supportedFamilies:[WidgetFamily] = {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular]
        } else {
            return [.systemSmall, .systemMedium]
        }
    }()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            coupleDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("너랑나랑 위젯")
        .description("소중한 인연을 위젯으로 만나보세요 !")
        .supportedFamilies(supportedFamilies)
        
    }
}

class RealmManager {
    // realm db 삭제
    // try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!) // remove realm db
    
    // Singleton object
    //
    static let shared: RealmManager = .init()
    
    // Realm instance
    // forSecurityApplicationGroupIdentifier -> app 쪽 realm 이랑 같은 값을 써서 app, widget realm 디비 공유 (app group)
    //
    private var realm: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ungchun.coupleDayProject")
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        do {
            return try Realm(configuration: config)
        } catch let error as NSError {
            print("error \(error.debugDescription)")
            fatalError("Can't continue further, no Realm available")
        }
    }
    
    // 현재 날짜 스트링 데이터 -> 현재 날짜 데이트 데이터
    // 현재 - 사귄날짜 = days
    //
    func getBeginCoupleDay() -> String {
        let realmUserData = realm.objects(RealmUserModel.self)
        let beginCoupleDay = realmUserData[0].beginCoupleDay
        let nowDayDataString = Date().toString
        let nowDayDataDate: Date = nowDayDataString.toDate
        let minus = Int(nowDayDataDate.millisecondsSince1970)-beginCoupleDay
        return String(describing: minus / 86400000)
    }
    func getMainBackgroundImage() -> Data {
        let realmImageData = realm.objects(RealmImageModel.self)
        let homeMainImage = realmImageData[0].homeMainImage
        return homeMainImage!
    }
}

// realm model
//
class RealmUserModel: Object {
    @objc dynamic var beginCoupleDay = 0
    @objc dynamic var zeroDayStartCheck = false
}
class RealmImageModel: Object {
    @objc dynamic var homeMainImage: Data? = nil
    @objc dynamic var myProfileImage: Data? = nil
    @objc dynamic var partnerProfileImage: Data? = nil
}

// color extension
//
extension Color {
    static let appMainColor = Color("appMainColor")
}

// date extension
//
extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    // date -> yyyy-MM-dd 형식의 string 으로 변환
    //
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}

// string extension
//
extension String {
    // yyyy-MM-dd 형식 string -> date 로 변환
    //
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)!
    }
}
