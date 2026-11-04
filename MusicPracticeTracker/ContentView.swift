//
//  ContentView.swift
//  MusicPracticeTracker
//
//  Created by ALLEN LIU on 10/26/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @State var testText: [String] = ["Task 1", "task 2", "Task 3"]
    
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
                        ForEach(testText, id: \.self) { thing in
                            HStack {
                                Text("*")
                                Text("\(thing)")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)

                        }
                    }

                }

                HStack(spacing: 12) {
                    NavigationLink(destination: LogView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.blue)
                            Text("View Logs")
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity, minHeight: 70)
                    }

                    //Start timer button
                    NavigationLink(destination: TimerView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.blue)
                            Text("Timer")
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity, minHeight: 70)
                    }
                }
                .frame(width: 385)
                
                HStack(spacing: 12) {
                    //show total min practiced
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.blue)
                        Text("Minutes practiced: \(totalMinutes)")
                            .foregroundStyle(.black)
                    }
                    .frame(maxWidth: .infinity, minHeight: 70)

                    //show total sessions
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.blue)
                        Text("Sessions: \(totalSes)")
                            .foregroundStyle(.black)
                    }
                    .frame(maxWidth: .infinity, minHeight: 70)
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
