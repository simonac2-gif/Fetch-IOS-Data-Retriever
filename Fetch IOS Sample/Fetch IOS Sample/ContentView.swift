//
//  ContentView.swift
//  Fetch IOS Sample
//
//  Created by Simon Cooper on 1/10/24.
//

import SwiftUI
import CoreData

struct Line: Hashable, Codable {
    let id: Int
    let listId: Int
    let name: String?
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @State private var data: [Line] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(sectionedData.keys.sorted(), id: \.self) { sectionIdx in
                    Section(header: Text("List \(sectionIdx)")) {
                        ForEach(self.sectionedData[sectionIdx]!, id: \.id) { line in
                            Text("\(line.id): \(line.listId): \(line.name ?? "")")
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Items List")
            .onAppear {
                fetchData()
            }
        }
    }

    private func fetchData() {
        guard let fileURL = Bundle.main.url(forResource: "hiring", withExtension: "json") else {
            print("Error: Unable to locate the JSON file.")
            return
        }

        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let lines = try decoder.decode([Line].self, from: jsonData)
                .filter {
                    guard let name = $0.name else {
                        print("Found null name for line with id \($0.id) and listId \($0.listId)")
                        return false
                    }
                    return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }
                .sorted { ($0.listId, $0.name ?? "") < ($1.listId, $1.name ?? "") }

            DispatchQueue.main.async {
                self.data = lines
            }
        } catch {
            print("Error decoding data: \(error)")
        }
    }

    private var sectionedData: [Int: [Line]] {
        Dictionary(grouping: data, by: { $0.listId })
    }

    private func addItem() {
        // Implement if needed
    }

    private func deleteItems(offsets: IndexSet) {
        // Implement if needed
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
