import SwiftUI
import UIKit
import WidgetKit

import RealmSwift

struct coupleDayEntry: TimelineEntry {
    var date: Date
    let size: CGSize
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> coupleDayEntry {
        coupleDayEntry(date: Date(), size: context.displaySize)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (coupleDayEntry) -> ()) {
        let entry = coupleDayEntry(date: Date(), size: context.displaySize)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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
    // try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!) // remove realm db
    
    static let shared: RealmManager = .init()

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

class RealmUserModel: Object {
    @objc dynamic var beginCoupleDay = 0
    @objc dynamic var zeroDayStartCheck = false
}
class RealmImageModel: Object {
    @objc dynamic var homeMainImage: Data? = nil
    @objc dynamic var myProfileImage: Data? = nil
    @objc dynamic var partnerProfileImage: Data? = nil
}

extension Color {
    static let appMainColor = Color("appMainColor")
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
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)!
    }
}
