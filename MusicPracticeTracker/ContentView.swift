//
//  ContentView.swift
//  MusicPracticeTracker
//
//  Created by ALLEN LIU on 10/26/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @AppStorage("task1") var task1: String = ""
    @AppStorage("task2") var task2: String = ""
    @AppStorage("task3") var task3: String = ""
    
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

                // A list user can put for 3 most important tasks
                ZStack(alignment: .center) {

                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 385, height: 200)
                        .foregroundStyle(.thinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 2)
                        )

                    
                    //For the task list
                    LazyVStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("*")
                            TextField("Enter task...", text: $task1, axis: .vertical)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)

                        HStack {
                            Text("*")
                            TextField("Enter task...", text: $task2, axis: .vertical)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)

                        HStack {
                            Text("*")
                            TextField("Enter task...", text: $task3, axis: .vertical)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                    }

                }

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
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SessionsData.self)
}
