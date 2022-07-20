//
//  ComplicationController.swift
//  coupleDayWatch WatchKit Extension
//
//  Created by 김성훈 on 2022/07/12.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let appMainColorAlaph40 = UIColor(red: 234/255, green: 188/255, blue: 188/255, alpha: 1)
    
    // MARK: - Complication Configuration
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "너랑나랑", supportedFamilies: [.modularSmall, .circularSmall, .graphicCircular])
        ]
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }
    
    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        
        //        var currentDate = Date()
        //        currentDate = currentDate.addingTimeInterval(60)
        //        handler(currentDate)
        //        handler(NSDate(timeIntervalSinceNow: 30) as Date)
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        switch complication.family {
        case .modularSmall:
            let tallBody = CLKComplicationTemplateModularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: UserInfo.shared.days == nil ? "days" : "\(UserInfo.shared.days!)"))
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tallBody)
            handler(entry)
            break
        case .circularSmall:
            let tallBody = CLKComplicationTemplateCircularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: UserInfo.shared.days == nil ? "days" : "\(UserInfo.shared.days!)"))
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tallBody)
            handler(entry)
            break
        case .graphicCircular:
            let tallBody = CLKComplicationTemplateGraphicCircularStackImage(line1ImageProvider: CLKFullColorImageProvider(fullColorImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: UserInfo.shared.days == nil ? "days" : "\(UserInfo.shared.days!)"))
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tallBody)
            handler(entry)
            break
        default:
            handler(nil)
            break
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
        
    }
    
    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        
        switch complication.family {
        case .modularSmall:
            let tallBody = CLKComplicationTemplateModularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: UserInfo.shared.days == nil ? "days" : "\(UserInfo.shared.days!)"))
            handler(tallBody)
            break
        case .circularSmall:
            let tallBody = CLKComplicationTemplateCircularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: UserInfo.shared.days == nil ? "days" : "\(UserInfo.shared.days!)"))
            handler(tallBody)
            break
        case .graphicCircular:
            let tallBody = CLKComplicationTemplateGraphicCircularStackImage(line1ImageProvider: CLKFullColorImageProvider(fullColorImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: UserInfo.shared.days == nil ? "days" : "\(UserInfo.shared.days!)"))
            handler(tallBody)
            break        default:
            handler(nil)
            break
        }
    }
}
