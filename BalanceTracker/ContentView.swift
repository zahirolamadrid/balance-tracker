//
//  ContentView.swift
//  BalanceTracker
//
//  Created by Zahiro on 8/14/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch balances sorted by date (newest first)
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Balance.timestamp, ascending: false)],
        animation: .default
    )
    private var balances: FetchedResults<Balance>

    var body: some View {
        NavigationView {
            VStack {
                // Dashboard
                if let latest = balances.first {
                    VStack {
                        Text("Last Balance")
                            .font(.headline)
                        Text("\(latest.total, specifier: "%.2f")")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        if let date = latest.timestamp {
                            Text("Created: \(date, formatter: itemFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                } else {
                    Text("No balance yet")
                        .foregroundColor(.gray)
                        .padding()
                }

                Divider()

                // List of all balances
                List {
                    ForEach(balances) { balance in
                        VStack(alignment: .leading) {
                            Text("\(balance.total, specifier: "%.2f")")
                                .font(.headline)
                            if let date = balance.timestamp {
                                Text("\(date, formatter: itemFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteBalances)
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: addBalance) {
                        Label("Add Balance", systemImage: "plus")
                    }
                }
            }
        }
    }

    // Add a new balance with random value (for now)
    private func addBalance() {
        withAnimation {
            let newBalance = Balance(context: viewContext)
            newBalance.timestamp = Date()
            newBalance.total = Double.random(in: 1000...5000) // placeholder

            saveContext()
        }
    }

    // Delete balances
    private func deleteBalances(offsets: IndexSet) {
        withAnimation {
            offsets.map { balances[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    // Save Core Data changes
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

// Date formatter
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
