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
    func placeholder(in context: Context) -> CurrentDate {
        CurrentDate(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (CurrentDate) -> ()) {
        let entry = CurrentDate(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CurrentDate>) -> ()) {
        var entries: [CurrentDate] = []

        // Get the current date
        let currentDate = Date()

        // Calculate the next 12 AM from the current date
        var next12AMComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        next12AMComponents.hour = 0
        next12AMComponents.minute = 0
        next12AMComponents.second = 0
        let next12AM = Calendar.current.date(from: next12AMComponents)!

        // Create entries for each day starting from the next 12 AM
        var entryDate = next12AM
        for _ in 0..<5 { // Generate five days of entries, you can adjust the number as per your requirement
            let entry = CurrentDate(date: entryDate)
            entries.append(entry)

            // Move to the next day (24 hours later)
            entryDate = Calendar.current.date(byAdding: .day, value: 1, to: entryDate)!
        }

        // Calculate the refresh date (12 AM of the next day)
        let nextRefreshDate = Calendar.current.date(byAdding: .day, value: 1, to: next12AM)!

        let timeline = Timeline(entries: entries, policy: .after(nextRefreshDate))
        completion(timeline)
    }
}


struct CurrentDate: TimelineEntry {
    let date: Date
}

struct DateWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            widgetWiew()
         default:
            widgetWiew()
        }
    }

    @ViewBuilder func widgetWiew() -> some View {
        VStack(alignment: .center, spacing: 0){
            Text(entry.date, format: Date.FormatStyle().weekday().month().day().year())
                .font(.largeTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .contentShape(Rectangle())
        .padding(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .foregroundColor(.accentColor)
        .containerBackground(for: .widget) {
            Color.black
        }
        .widgetAccentable()
    }
}

@main
struct DateWidget: Widget {
    let kind: String = "DateWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DateWidgetEntryView(entry: entry)
        }
        .containerBackgroundRemovable(false)
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
