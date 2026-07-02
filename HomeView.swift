//
//  HomeView.swift
//  SecondBrainAI
//
//  Created by Grzegorz Bilski on 15.06.26.
//

import SwiftUI
import _SwiftData_SwiftUI

struct HomeView: View {

    @Query(
        sort: \BrainEntry.createdAt,
        order: .reverse
    )
    private var entries: [BrainEntry]
        
    @Environment(\.modelContext)
    private var modelContext

        @State
        private var showAddNote = false
        
        @State
        private var searchText = ""
    
    private var filteredEntries: [BrainEntry] {

        if searchText.isEmpty {
            return entries
        }

        return entries.filter {

            $0.title.localizedCaseInsensitiveContains(searchText)
            ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    var body: some View {

NavigationStack {
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    Text("Entries count: \(entries.count)")
                        .foregroundStyle(.white)
                    VStack(alignment: .leading, spacing: 24) {
                        
                        headerSection
                        
                        searchBar
                        
                        categorySection
                        
                        notesSection
                        
                        voiceIdeasSection
                    }
                    .padding()
                }
            }.sheet(isPresented: $showAddNote) {
                
                AddBrainEntryView()
            }
        }.onAppear {
            
            checkForSharedText()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.willEnterForegroundNotification
            )
        ) { _ in

            checkForSharedText()
        }
    }
    
    var searchBar: some View {

            HStack {

                HStack(spacing: 12) {

                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)

                    TextField("Search your brain...",text: $searchText)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Button {

                } label: {

                    Image(systemName: "slider.horizontal.3")
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
    }
    
    var categorySection: some View {

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 12) {

                    categoryChip(title: "All Notes", selected: true)

                    categoryChip(title: "Favorites")

                    categoryChip(title: "AI Summaries")

                    categoryChip(title: "Trash")
                }
            }
        }

        func categoryChip(title: String, selected: Bool = false) -> some View {

            Text(title)
                .fontWeight(.medium)
                .foregroundStyle(selected ? .white : .gray)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    selected ?
                    Color.purple :
                    Color.white.opacity(0.05)
                )
                .clipShape(Capsule())
        }
    var headerSection: some View {

            VStack(alignment: .leading, spacing: 12) {

                Text("Good morning 👋")
                    .foregroundStyle(.purple)

                HStack {

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Your Notes")
                            .font(.system(size: 42, weight: .bold))

                        Text("Capture ideas, organize thoughts, and let AI help you understand more.")
                            .foregroundStyle(.gray)
                    }

                    Spacer()

                    Button {
                        
                        showAddNote = true

                    }
                    
                    
                    label: {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .frame(width: 64, height: 64)
                            .background(Color.purple)
                            .clipShape(Circle())
                    }
                }
            }
            .foregroundStyle(.white)
        }
    
}

private extension HomeView {
    
    var notesSection: some View {
        
        VStack(spacing: 18) {
            
            ForEach(filteredEntries) { entry in
                
                NavigationLink {
                    
                    BrainEntryDetailView(
                        entry: entry
                    )
                    
                } label: {
                    
                    NoteCardView(
                        note: entry
                    )
                }
            }
            .onDelete(perform: deleteEntry)
        }
    }
    private func deleteEntry(
        at offsets: IndexSet
    ) {
        
        for index in offsets {
            
            let entry = filteredEntries[index]
            
            modelContext.delete(entry)
        }
    }
    private func checkForSharedText() {

        print("CHECKING...")
        
        guard let defaults = UserDefaults(
            suiteName: "group.com.grzegorzbilski.secondbrainai"
        ) else {
            return
        }

        guard let sharedText =
            defaults.string(forKey: "sharedText")
        else {
            return
        }
        let previewTitle = String(
             sharedText.prefix(40)
         )

        let entry = BrainEntry(
            title: previewTitle,
            content: sharedText
        )

        modelContext.insert(entry)
        
        defaults.removeObject(
            forKey: "sharedText"
        )
 


        print(sharedText)
        print("REMOVED")
    }
}
private extension HomeView {

    var voiceIdeasSection: some View {

        NavigationLink {

            VoiceRecorderView()

        } label: {

            HStack(spacing: 16) {

                Image(systemName: "mic.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.purple)

                VStack(alignment: .leading, spacing: 4) {

                    Text("Voice Ideas")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("Capture ideas instantly")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)

            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
}
    #Preview {
        HomeView()
    }
    

