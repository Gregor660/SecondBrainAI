//
//  AddNoteView.swift
//  SecondBrainAI
//
//  Created by Grzegorz Bilski on 15.06.26.
//

import SwiftUI
import SwiftData

struct AddBrainEntryView: View {

    @Environment(\.dismiss)
    private var dismiss

    @State private var title = ""
    @State private var content = ""
    @Environment(\.modelContext)
    private var modelContext
    
    var body: some View {

        NavigationStack {

            Form {

                Section("Title") {

                    TextField(
                        "Enter title",
                        text: $title
                    )
                }

                Section("Content") {

                    TextEditor(text: $content)
                        .frame(height: 200)
                }
            }
            .navigationTitle("New Note")
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button("Save") {

                        guard !title.isEmpty else {
                            return
                        }

                        let entry = BrainEntry(
                            title: title,
                            content: content
                        )
                        modelContext.insert(entry)
                        
                        print("SAVED:", title)
                        dismiss()
                    }
                }
            }
        }
    }
}
