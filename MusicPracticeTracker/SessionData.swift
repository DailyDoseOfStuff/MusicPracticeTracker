//
//  SessionData.swift
//  MusicPracticeTracker
//a
//  Created by ALLEN LIU on 10/29/26.
//

import Foundation
import SwiftData

@Model
class SessionsData {

    var sesLength: String
    var dateOfSes: Date
    var notes: String

    init(sesLength: String, dateOfSes: Date, notes: String = "") {
        self.sesLength = sesLength
        self.dateOfSes = dateOfSes
        self.notes = notes
    }

    //format the date into a string
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: dateOfSes)
    }

    //format time into something readable
    func formatTime(_ totalSec: Int) -> String {
        let minutes = totalSec / 60
        let seconds = totalSec % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    
    
}
