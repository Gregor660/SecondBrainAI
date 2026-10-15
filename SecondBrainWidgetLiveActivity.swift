//
//  SecondBrainWidgetLiveActivity.swift
//  SecondBrainWidget
//
//  Created by Grzegorz Bilski on 30.06.26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SecondBrainWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SecondBrainWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SecondBrainWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SecondBrainWidgetAttributes {
    fileprivate static var preview: SecondBrainWidgetAttributes {
        SecondBrainWidgetAttributes(name: "World")
    }
}

extension SecondBrainWidgetAttributes.ContentState {
    fileprivate static var smiley: SecondBrainWidgetAttributes.ContentState {
        SecondBrainWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SecondBrainWidgetAttributes.ContentState {
         SecondBrainWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SecondBrainWidgetAttributes.preview) {
   SecondBrainWidgetLiveActivity()
} contentStates: {
    SecondBrainWidgetAttributes.ContentState.smiley
    SecondBrainWidgetAttributes.ContentState.starEyes
}
