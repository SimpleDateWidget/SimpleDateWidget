//
//  DateWidget.swift
//  DateWidget
//
//  Created by BAproductions on 1/18/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    //Get current date
    let currentDate = Date()
    func placeholder(in context: Context) -> CurrentDate {
        CurrentDate(date: currentDate)
    }

    func getSnapshot(in context: Context, completion: @escaping (CurrentDate) -> ()) {
        let entry = CurrentDate(date: currentDate)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [CurrentDate] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
            let entry = CurrentDate(date: currentDate)
            entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CurrentDate: TimelineEntry {
    let date: Date
}

struct DateWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .center, spacing: 0){
            Text(entry.date, format: Date.FormatStyle().weekday().month().day().year())
                .font(.largeTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .contentShape(Rectangle())
        .padding(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .foregroundColor(.accentColor)
        .background(.black)
    }
}

@main
struct DateWidget: Widget {
    let kind: String = "DateWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DateWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Date Widget")
        .description("Display The Ccrrent Date.")
        .supportedFamilies([.systemMedium])
    }
}

struct DateWidget_Previews: PreviewProvider {
    static var previews: some View {
        //Get current date
        let currentDate = Date()
        DateWidgetEntryView(entry: CurrentDate(date: currentDate))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
