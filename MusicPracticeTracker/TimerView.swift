//
//  TimerView.swift
//  MusicPracticeTracker
//a
//  Created by ALLEN LIU on 10/26/26.
//

import Combine
import SwiftData
import SwiftUI

//select screen
struct TimerView: View {

    //in seconds
    @State var time: Int = 0
    @State var userInput: String = ""

    //swap between select and countdown
    @State var viewTrigger: Bool = false

    //alert for custome timer pop-up
    @State var alertTrigger: Bool = false

    var body: some View {

        NavigationStack {
            VStack {

                Text("Timer Length")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .bold()

                HStack(spacing: 12) {
                    TimerButton(label: "30 Minutes") {
                        time = 30 * 60
                        viewTrigger = true
                    }
                    TimerButton(label: "45 Minutes") {
                        time = 45 * 60
                        viewTrigger = true
                    }
                }
                .frame(width: 385)

                HStack(spacing: 12) {
                    TimerButton(label: "1 Hour") {
                        time = 60 * 60
                        viewTrigger = true
                    }
                    TimerButton(label: "Custom") {
                        alertTrigger.toggle()
                    }
                }
                .frame(width: 385)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert("Enter Custom Time", isPresented: $alertTrigger) {
                //custom time
                TextField("Type time here in minutes", text: $userInput)

                Button("Cancel", role: .cancel) {}

                Button("Start") {
                    if let inputTime = Int(userInput) {
                        time = inputTime * 60
                        viewTrigger = true
                    } else {
                        //fail silently
                        print("error")
                    }
                }

            }
            .background(
                LinearGradient(
                    colors: [.indigo, .purple, .pink, .orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

            )
            .navigationDestination(isPresented: $viewTrigger) {
                TimerCountDown(time: time)
            }

        }
    }

}

struct SaveSessionView: View {
    let elapsedSec: Int
    let onSave: () -> Void

    @State var tasks: [String] = []
    @State var selectedTasks: Set<String> = []
    @State var customNote: String = ""

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    var body: some View {
        NavigationStack {
            Form {
                Section("What did you work on?") {
                    ForEach(tasks.filter { !$0.isEmpty }, id: \.self) { task in
                        HStack {
                            Text(task)
                            Spacer()
                            if selectedTasks.contains(task) {
                                Image(systemName: "checkmark").foregroundStyle(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedTasks.contains(task) {
                                selectedTasks.remove(task)
                            } else {
                                selectedTasks.insert(task)
                            }
                        }
                    }


                }

                Section("Additional notes (optional)") {
                    TextField("Anything else to log...", text: $customNote, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Session Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveSession() }
                }
            }
            .onAppear { loadTasks() }
        }
    }

    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            tasks = decoded
        }
    }

    func saveSession() {
        let minutesPracticed = max(1, elapsedSec / 60)
        var noteParts: [String] = []
        if !selectedTasks.isEmpty { noteParts.append(selectedTasks.joined(separator: ", ")) }
        if !customNote.isEmpty { noteParts.append(customNote) }
        let finalNote = noteParts.isEmpty ? "No notes" : noteParts.joined(separator: "\n")

        context.insert(SessionsData(sesLength: String(minutesPracticed), dateOfSes: Date(), notes: finalNote))
        try? context.save()
        onSave()
        dismiss()
    }
}

//button config
struct TimerButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title2)
                .foregroundStyle(.white)
                .bold()
                .frame(maxWidth: .infinity, minHeight: 350)
                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}

//CountDown timer
struct TimerCountDown: View {

    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    @State var save: Bool = false
    @State var userInput: String = ""

    @State var time: Int
    @State var elapsedSec: Int = 0
    @State var isRunning: Bool = true

    //go back to original view
    @Environment(\.dismiss) var dismiss
    
    //persistence stuff
    @Environment(\.modelContext) var context
    @Query var Logs: [SessionsData]

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text(formatTime(time))
                .font(.system(size: 48, weight: .bold, design: .monospaced))

            HStack(spacing: 16) {
                Button {
                    isRunning.toggle()
                } label: {
                    Text(isRunning ? "Pause" : "Start")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .glassEffect(
                            .clear.interactive(),
                            in: .rect(cornerRadius: 20)
                        )
                }
                .buttonStyle(.plain)

                Button {
                    isRunning = false
                    if elapsedSec > 0 {
                        save = true
                    } else{
                        dismiss()
                    }
                } label: {
                    Text("Quit")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .glassEffect(
                            .clear.interactive(),
                            in: .rect(cornerRadius: 20)
                        )
                }
                .buttonStyle(.plain)

            }
            .frame(maxWidth: 320, minHeight: 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.cyan, .blue, .white, .teal],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .onReceive(timer) { _ in
            guard isRunning else { return }
            if time > 0 {
                time -= 1
                elapsedSec += 1
            } else {
                isRunning = false
                save = true
                //pop-up

            }
        }
        .sheet(isPresented: $save) {
            SaveSessionView(elapsedSec: elapsedSec) {
                elapsedSec = 0
                dismiss()
            }
        }

    }

}

#Preview {
    TimerView()
        .modelContainer(for: SessionsData.self)
}
