//
//  ContentView.swift
//  MusicPracticeTracker
//
//  Created by ALLEN LIU on 10/26/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
            let decoded = try? JSONDecoder().decode([String].self, from: data) {
            tasks = decoded.isEmpty ? [""] : decoded
        }
    }
    
    func saveTasks(){
        if let encoded = try? JSONEncoder().encode(tasks){
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
    
    var totalSes: Int {
        logs.count
    }
    
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
                                    TextField("enter task...", text: $tasks[index])
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
                        guard let old = oldValue, old < tasks.count, tasks[old].isEmpty, tasks.count > 1 else { return }
                        tasks.remove(at: old)
                        if let new = newValue, new > old {
                            focusedIndex = new - 1
                        }
                        saveTasks()
                    }
                }
                .frame(width: 385, height: 200)

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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [.purple, .gray, .indigo, .white],
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .ignoresSafeArea()
            )
            .onAppear{ loadTasks() }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SessionsData.self)
}
