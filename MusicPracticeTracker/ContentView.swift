//
//  ContentView.swift
//  MusicPracticeTracker
//
//  Created by ALLEN LIU on 10/26/26.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
            let decoded = try? JSONDecoder().decode([String].self, from: data)
        {
            tasks = decoded.isEmpty ? [""] : decoded
        }
    }

    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }

    @State private var tasks: [String] = [""]
    @FocusState var focusedIndex: Int?

    @Query var logs: [SessionsData]

    var totalMinutes: Int {
        logs.reduce(0) {
            $0 + (Int($1.sesLength) ?? 0)
        }
    }

    var avgMin: Double {
        guard !logs.isEmpty else { return 0 }
        let total = logs.reduce(0.0) {
            $0 + (Double($1.sesLength) ?? 0)
        }
        return total / Double(totalSes)
    }

    var totalSes: Int {
        logs.count
    }

    @AppStorage("goal") var weeklyGoal: Int = 5  //in minutes

    var thisWeekLogs: [SessionsData] {
        let now = Date()
        return logs.filter {
            Calendar.current.isDate(
                $0.dateOfSes,
                equalTo: now,
                toGranularity: .weekOfYear
            )
        }
    }

    var weeklyProgress: Double {
        let minutes = thisWeekLogs.reduce(0) {
            $0 + (Int($1.sesLength) ?? 0)
        }
        return min(Double(minutes) / Double(weeklyGoal), 1.0)

    }

    var weeklyMin: Double {
        let minutes = thisWeekLogs.reduce(0) {
            $0 + (Int($1.sesLength) ?? 0)
        }
        return (Double(minutes))
    }

    
    //Changing Practice Goals
    
    @State var goalChange: Bool = false
    @State var changeMin: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 12) {

                Text("Practice Tracker")
                    .bold()
                    .font(.largeTitle)

                // A list user can put for most important tasks
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 2)
                        )

                    ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(tasks.indices, id: \.self) { index in
                                HStack(alignment: .top) {
                                    Text("•")
                                    TextField(
                                        "enter task...",
                                        text: $tasks[index]
                                    )
                                    .focused($focusedIndex, equals: index)
                                    .onSubmit {
                                        tasks.insert("", at: index + 1)
                                        focusedIndex = index + 1
                                        saveTasks()
                                    }
                                    .onChange(of: tasks[index]) { _, _ in
                                        saveTasks()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onChange(of: focusedIndex) { oldValue, newValue in
                        guard let old = oldValue, old < tasks.count,
                            tasks[old].isEmpty, tasks.count > 1
                        else { return }
                        tasks.remove(at: old)
                        if let new = newValue, new > old {
                            focusedIndex = new - 1
                        }
                        saveTasks()
                    }
                }
                .frame(width: 385, height: 200)

                
                HStack(spacing: 12){
                    Text("Weekly goal: \(weeklyMin.formatted(.number.precision(.fractionLength(2)))) / \(weeklyGoal) min")
                    //to change the goal practice time
                    Button{
                        goalChange.toggle()
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(.black)
                    }
                }
                
                
                //progress bar
                ProgressView(value: weeklyProgress)
                    .progressViewStyle(.linear)
                    .tint(.white)
                    .controlSize(.large)
                    .frame(maxWidth: 380, maxHeight: 20)
                    .background(.purple)
                    .padding(6)
                
                //View buttons
                HStack(spacing: 12) {
                    NavigationLink(destination: LogView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.clear)
                            Text("View Logs")
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .glassEffect(
                            .clear.interactive(),
                            in: .rect(cornerRadius: 20)
                        )
                    }

                    //Start timer button
                    NavigationLink(destination: TimerView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.clear)
                            Text("Timer")
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .glassEffect(
                            .clear.interactive(),
                            in: .rect(cornerRadius: 20)
                        )
                    }
                }
                .frame(width: 385)

                LazyVStack(spacing: 12) {
                    //average minutes across sessons
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.thinMaterial)
                            .glassEffect(
                                .clear.interactive(),
                                in: .rect(cornerRadius: 20)
                            )
                        Text(
                            "Average minutes/week: \(avgMin, format: .number.precision(.fractionLength(2)))"
                        )
                        .foregroundStyle(.black)
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .glassEffect(
                        .clear.interactive(),
                        in: .rect(cornerRadius: 20)
                    )

                    //show total min practiced
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.thinMaterial)
                            .glassEffect(
                                .clear.interactive(),
                                in: .rect(cornerRadius: 20)
                            )
                        Text("Minutes practiced: \(totalMinutes)")
                            .foregroundStyle(.black)
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .glassEffect(
                        .clear.interactive(),
                        in: .rect(cornerRadius: 20)
                    )

                    //show total sessions
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.thinMaterial)
                            .glassEffect(
                                .clear.interactive(),
                                in: .rect(cornerRadius: 20)
                            )
                        Text("Sessions: \(totalSes)")
                            .foregroundStyle(.black)
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)

                }
                .frame(width: 385)

                Spacer()

            }
            .alert("Enter Custom Time", isPresented: $goalChange) {
                //custom time
                TextField("Type time here in minutes", text: $changeMin)

                Button("Cancel", role: .cancel) {}

                Button("Save") {
                    if let inputTime = Int(changeMin) {
                        weeklyGoal = inputTime
                        goalChange = false
                        changeMin = ""
                    } else {
                        //fail silently
                        print("error")
                        changeMin = ""
                    }
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [.purple, .gray, .indigo, .white],
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .ignoresSafeArea()
            )
            .onAppear { loadTasks() }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SessionsData.self)
}
