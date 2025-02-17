//
//  DashBoardView.swift
//  BookMySlot_Interviewer
//
//  Created by admin on 15/02/25.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: InterviewSlot.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \InterviewSlot.date, ascending: true)]
    ) private var slots: FetchedResults<InterviewSlot>
    
    @State private var selectedSlot: InterviewSlot?
    @State private var showEditView = false
    @State private var showAddSlotView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Interview Slots")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                List {
                    ForEach(slots, id: \.self) { slot in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Date: \(formattedDate(slot.date))")
                                    .font(.headline)
                                Text("Time: \(slot.time ?? "N/A")")
                                    .foregroundColor(.gray)
                                Text("Interviewer: \(slot.interviewerName ?? "Not Assigned")")
                                    .foregroundColor(.blue)
                                Text("Subject: \(slot.subject ?? "No Subject")")
                                    .foregroundColor(.purple)
                                Text("Status: \(slot.status ?? "Unknown")")
                                    .foregroundColor(statusColor(slot.status ?? "Unknown"))
                            }
                            Spacer()
                            // Pencil Icon for Editing
                            Button(action: {
                                selectedSlot = slot
                                showEditView.toggle()
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .onDelete(perform: deleteSlot) // Swipe left to delete
                }
                
                Spacer()
                
                Button(action: { showAddSlotView.toggle() }) {
                    Text("Add Slot")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .sheet(isPresented: $showAddSlotView) {
                AddSlotView()
            }
            .sheet(item: $selectedSlot) { slot in
                EditSlotView(slot: slot)
            }
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func deleteSlot(at offsets: IndexSet) {
        for index in offsets {
            let slot = slots[index]
            viewContext.delete(slot)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error deleting slot: \(error.localizedDescription)")
        }
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "Available": return .green
        case "Booked": return .orange
        case "Completed": return .gray
        default: return .black
        }
    }
}
