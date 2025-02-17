//
//  EditSlotView.swift
//  BookMySlot_Interviewer
//
//  Created by admin on 15/02/25.
//

import SwiftUI

struct EditSlotView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @State private var date: Date
    @State private var time: String
    @State private var interviewerName: String
    @State private var subject: String
    @State private var status: String

    let statuses = ["Available", "Booked", "Completed"]

    var slot: InterviewSlot

    init(slot: InterviewSlot) {
        self.slot = slot
        _date = State(initialValue: slot.date ?? Date())
        _time = State(initialValue: slot.time ?? "")
        _interviewerName = State(initialValue: slot.interviewerName ?? "")
        _subject = State(initialValue: slot.subject ?? "")
        _status = State(initialValue: slot.status ?? "Available")
    }

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Select Date", selection: $date, displayedComponents: .date)
                TextField("Enter Time", text: $time)
                TextField("Interviewer Name", text: $interviewerName)
                TextField("Subject", text: $subject)
                Picker("Status", selection: $status) {
                    ForEach(statuses, id: \.self) { Text($0) }
                }
                
                Button("Save Changes") {
                    updateSlot()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Edit Interview Slot")
        }
    }

    private func updateSlot() {
        slot.date = date
        slot.time = time
        slot.interviewerName = interviewerName
        slot.subject = subject 
        slot.status = status

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error updating slot: \(error.localizedDescription)")
        }
    }
}
