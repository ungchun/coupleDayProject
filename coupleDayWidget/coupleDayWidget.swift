//
//  coupleDayWidget.swift
//  coupleDayWidget
//
//  Created by 김성훈 on 2022/07/07.
//

import WidgetKit
import SwiftUI
import UIKit
import RealmSwift

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), size: context.displaySize)
    }
    
    // WidgetKit은 위젯을 추가할 때와 같이 일시적인 상황에서 위젯을 표시하기 위해서 Snapshot 요청
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), size: context.displaySize)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, size: context.displaySize)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let size: CGSize
}

struct coupleDayWidgetEntryView : View {
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    var entry: Provider.Entry
    
    var body: some View {
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
        case .systemLarge:
            Text("systemLarge")
        case .systemExtraLarge:
            Text("systemExtraLarge")
        @unknown default:
            Text("unknown")
        }
    }
}

@main
struct coupleDayWidget: Widget {
    let kind: String = "coupleDayWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            coupleDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("너랑나랑 위젯")
        .description("소중한 인연을 위젯으로 만나보세요 !")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

class RealmManager {
    // realm db 삭제
    // try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!) // remove realm db
    
    // Singleton object
    static let shared: RealmManager = .init()
    
    // Realm instance
    private var realm: Realm {
        print("realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" )
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ungchun.coupleDayProject")
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        return try! Realm(configuration: config)
    }
    
    func getBeginCoupleDay() -> String {
        let realmUserData = realm.objects(User.self)
        let beginCoupleDay = realmUserData[0].beginCoupleDay
        let nowDayDataString = Date().toString // 현재 날짜 스트링 데이터
        let nowDayDataDate: Date = nowDayDataString.toDate // 현재 날짜 데이트 데이터
        let minus = Int(nowDayDataDate.millisecondsSince1970)-beginCoupleDay // 현재 - 사귄날짜 = days
        return String(describing: minus / 86400000)
    }
    func getMainBackgroundImage() -> Data {
        let realmImageData = realm.objects(ImageModel.self)
        let mainImageData = realmImageData[0].mainImageData
        //        let myProfileImageData = realmImageData[0].myProfileImageData
        //        let partnerProfileImageData = realmImageData[0].partnerProfileImageData
        return mainImageData!
    }
}

class User: Object {
    @objc dynamic var beginCoupleDay = 0
}
class ImageModel: Object {
    @objc dynamic var mainImageData: Data? = nil
    @objc dynamic var myProfileImageData: Data? = nil
    @objc dynamic var partnerProfileImageData: Data? = nil
}

extension Color {
    static let appMainColor = Color("appMainColor")
}

// MARK: Date
extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    var toString: String { // date -> yyyy-MM-dd 형식의 string 으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    var toStoryString: String { // date -> yyyy.MM.dd 형식의 string 으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy.MM.dd(E)"
        return dateFormatter.string(from: self)
    }
    var toAnniversaryString: String { // date -> MM/dd 형식의 string 으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: self)
    }
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
}

// MARK: String
extension String {
    var toDate: Date { // yyyy-MM-dd 형식 string -> date 로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)!
    }
}

