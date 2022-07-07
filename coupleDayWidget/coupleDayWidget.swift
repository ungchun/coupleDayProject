//
//  coupleDayWidget.swift
//  coupleDayWidget
//
//  Created by 김성훈 on 2022/07/07.
//

import WidgetKit
import SwiftUI
import UIKit


struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), day: "day", image: UIImage(named: "coupleImg")!, size: context.displaySize)
    }
    
    // WidgetKit은 위젯을 추가할 때와 같이 일시적인 상황에서 위젯을 표시하기 위해서 Snapshot 요청
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), day: "day", image: UIImage(named: "coupleImg")!, size: context.displaySize)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, day: "day", image: UIImage(named: "coupleImg")!, size: context.displaySize)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    
    let day: String
    let image: UIImage
    let size: CGSize
}


//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date())
//    }
//
//    // WidgetKit은 위젯을 추가할 때와 같이 일시적인 상황에서 위젯을 표시하기 위해서 Snapshot 요청
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date())
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}

//struct SimpleEntry: TimelineEntry {
//    let date: Date
//}

import RealmSwift

extension Color {
    static let appMainColor = Color("appMainColor")
}

let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ungchun.coupleDayProject")?.appendingPathComponent("shared.realm")
let config = Realm.Configuration(fileURL: path)

struct coupleDayWidgetEntryView : View {
    
    let realm = try? Realm(configuration: config)
    
//    let fileURL = FileManager.default
//        .containerURL(forSecurityApplicationGroupIdentifier: "group.io.realm.app_group")!
//        .appendingPathComponent("default.realm")
//    let config = Realm.Configuration(fileURL: fileURL)
//    let realm = try Realm(configuration: config)
//
//    let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?.appendingPathComponent("\(fileName).realm")
//    let config = Realm.Configuration(fileURL: path)
//    realm = try? Realm(configuration: config)
    
    
//    var realm: Realm!
//
//    // 날짜 세팅
//    func setBeginCoupleDay() {
//        realm = try? Realm()
//        let realmUserData = realm.objects(User.self)
//        let beginCoupleDay = realmUserData[0].beginCoupleDay
//        let nowDayDataString = Date().toString // 현재 날짜 스트링 데이터
//        let nowDayDataDate: Date = nowDayDataString.toDate // 현재 날짜 데이트 데이터
//        let minus = Int(nowDayDataDate.millisecondsSince1970)-beginCoupleDay // 현재 - 사귄날짜 = days
//        self.beginCoupleDay = String(describing: minus / 86400000)
//        CoupleTabViewModel.publicBeginCoupleDay = String(describing: minus / 86400000)
//        self.beginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(beginCoupleDay) / 1000).toStoryString
//        CoupleTabViewModel.publicBeginCoupleFormatterDay = Date(timeIntervalSince1970: TimeInterval(beginCoupleDay) / 1000).toStoryString
//    }
    

    @Environment(\.widgetFamily) private var widgetFamily
    
    var entry: Provider.Entry
    
    //    var body: some View {
    //        Text(entry.date, style: .time)
    //    }
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            ZStack {
                VStack {
                    Image(uiImage: UIImage(systemName: "heart.fill")!)
                        .renderingMode(.template)
                        .foregroundColor(.appMainColor)
//                        .foregroundColor(Color("appMainColor"))
                    Text("Hello")
                }
            }
            .background(
                Image(uiImage: entry.image)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: entry.size.width, height: entry.size.height)
                    .scaledToFill()
            )
        case .systemMedium:
            ZStack {
                Text("Hello")
            }
            .background(
                Image(uiImage: entry.image)
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

//struct coupleDayWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        coupleDayWidgetEntryView(entry: SimpleEntry(date: Date(), day: "day", image: UIImage(named: "coupleImg")!))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
