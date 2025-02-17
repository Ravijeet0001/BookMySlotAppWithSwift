//
//  AddSlotView.swift
//  BookMySlot_Interviewer
//
//  Created by admin on 15/02/25.
//

import SwiftUI

struct AddSlotView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @State private var date = Date()
    @State private var time = ""
    @State private var interviewerName = ""
    @State private var subject = ""
    @State private var status = "Available"

    let statuses = ["Available", "Booked", "Completed"]

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
                
                Button("Save") {
                    addSlot()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Add Interview Slot")
        }
    }

    private func addSlot() {
        let newSlot = InterviewSlot(context: viewContext)
        newSlot.date = date
        newSlot.time = time
        newSlot.interviewerName = interviewerName
        newSlot.subject = subject
        newSlot.status = status

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving slot: \(error.localizedDescription)")
        }
    }
}
