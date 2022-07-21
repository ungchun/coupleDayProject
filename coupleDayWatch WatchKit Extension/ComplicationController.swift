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
    }
    
    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date(timeIntervalSinceNow: 60*60))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        var value = ""
        if DayInfo.shared.days != nil {
            let nowDayDataString = Date().toString
            let nowDayDataDate = nowDayDataString.toDate
            let minus = nowDayDataDate.millisecondsSince1970-Int64(DayInfo.shared.days!)!
            value = String(describing: minus / 86400000)
        }
        
        switch complication.family {
        case .modularSmall:
            let tallBody = CLKComplicationTemplateModularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: DayInfo.shared.days == nil ? "days" : "\(value) days"))
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tallBody)
            handler(entry)
            break
        case .circularSmall:
            let tallBody = CLKComplicationTemplateCircularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: DayInfo.shared.days == nil ? "days" : "\(value) days"))
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tallBody)
            handler(entry)
            break
        case .graphicCircular:
            let tallBody = CLKComplicationTemplateGraphicCircularStackImage(line1ImageProvider: CLKFullColorImageProvider(fullColorImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: DayInfo.shared.days == nil ? "days" : "\(value) days"))
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tallBody)
            handler(entry)
            break
        default:
            handler(nil)
            break
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }
    
    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        var value = ""
        if DayInfo.shared.days != nil {
            let nowDayDataString = Date().toString
            let nowDayDataDate = nowDayDataString.toDate
            let minus = nowDayDataDate.millisecondsSince1970-Int64(DayInfo.shared.days!)!
            value = String(describing: minus / 86400000)
        }
        
        switch complication.family {
        case .modularSmall:
            let tallBody = CLKComplicationTemplateModularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: DayInfo.shared.days == nil ? "days" : "\(value) days"))
            handler(tallBody)
            break
        case .circularSmall:
            let tallBody = CLKComplicationTemplateCircularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: DayInfo.shared.days == nil ? "days" : "\(value) days"))
            handler(tallBody)
            break
        case .graphicCircular:
            let tallBody = CLKComplicationTemplateGraphicCircularStackImage(line1ImageProvider: CLKFullColorImageProvider(fullColorImage: (UIImage(systemName: "heart")?.withTintColor(appMainColorAlaph40))!), line2TextProvider: CLKTextProvider(format: DayInfo.shared.days == nil ? "days" : "\(value) days"))
            handler(tallBody)
            break        default:
            handler(nil)
            break
        }
    }
}
