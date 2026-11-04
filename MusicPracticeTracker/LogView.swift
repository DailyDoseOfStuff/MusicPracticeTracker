//
//  LogView.swift
//  MusicPracticeTracker
//a
//  Created by ALLEN LIU on 10/28/26.
//

import SwiftData
import SwiftUI

struct LogView: View {

    @Environment(\.modelContext) var context
    @Query(sort: \SessionsData.dateOfSes, order: .reverse) var logs:
        [SessionsData]

    var body: some View {

        VStack {
            List {
                if logs.isEmpty {
                    Text("No practice sessions yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(logs) { session in
                        LogCard(logCard: session)
                    }
                }

            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(
                colors: [.mint, .green, .yellow, .white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}

struct LogCard: View {

    @State var logCard: SessionsData

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(logCard.formatDate())
                    .font(.headline)
                Spacer()
                Text("\(logCard.sesLength) min")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.blue)
            }
            Text(logCard.notes)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LogView()
        .modelContainer(for: SessionsData.self)
}
