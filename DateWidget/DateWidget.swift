//
//  DateWidget.swift
//  DateWidget
//
//  Created by BAproductions on 1/18/22.
//

import SwiftUI
import Intents
import WidgetKit
import AppIntents

struct DateAppIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Copy the current date in the 00/00/00 format"
    static var description = IntentDescription("Copy the current date in the 00/00/00 format ")
    static let currentDate = Date()
    
    func perform() async throws -> some IntentResult {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString("\(DateAppIntent.currentDate.formatDT(format: "MM/dd/yyyy"))", forType: NSPasteboard.PasteboardType.string)
        return .result()
    }
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CurrentDate {
        CurrentDate(date: Date())
    }

    func snapshot(for configuration: DateAppIntent, in context: Context) async -> CurrentDate {
        CurrentDate(date: Date())
    }

    func timeline(for configuration: DateAppIntent, in context: Context) async -> Timeline<CurrentDate> {
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

        return Timeline(entries: entries, policy: .after(nextRefreshDate))
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
        Button(intent: DateAppIntent()) {
            VStack(alignment: .center, spacing: 0){
                Text(entry.date, format: Date.FormatStyle().weekday().month().day().year())
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .padding(0)
            .contentMargins(0)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .padding(-50)
        .contentMargins(-50)
        .buttonStyle(.plain)
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
        AppIntentConfiguration(
            kind: kind,
            intent: DateAppIntent.self,
            provider: Provider()
        ) { entry in
            DateWidgetEntryView(entry: entry)
        }
        .containerBackgroundRemovable(true)
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Date Widget")
        .description("Display The Ccrrent Date.")
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
