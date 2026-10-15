//
//  EditBrainEntryView.swift
//  SecondBrainAI
//
//  Created by Grzegorz Bilski on 19.06.26.
//

import SwiftUI

struct EditBrainEntryView: View {

    @Environment(\.dismiss)
    private var dismiss

    let entry: BrainEntry

    @State private var title: String
    @State private var content: String

    init(entry: BrainEntry) {

        self.entry = entry

        _title = State(initialValue: entry.title)
        _content = State(initialValue: entry.content)
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Title") {

                    TextField(
                        "Title",
                        text: $title
                    )
                }

                Section("Content") {

                    TextEditor(text: $content)
                        .frame(height: 250)
                }
            }
            .navigationTitle("Edit Entry")
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button("Save") {

                        entry.title = title
                        entry.content = content

                        dismiss()
                    }
                }
            }
        }
    }
}
