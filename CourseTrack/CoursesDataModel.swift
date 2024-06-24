//
//  CoursesDataModel.swift
//  CourseTrack
//
//  Created by Jake Maidment on 16/06/2024.
//

import Foundation

struct Subject: Codable, Identifiable {
    let id = UUID()
    let subjectName: String
    var courses: [Course]
}




struct Course: Codable, Identifiable {
    let id = UUID()
    let courseTitle: String
    let description: String
    let instructors: [Instructor]
    var enrolled: Bool = false
    var isEnrolled: Bool = false

    private enum CodingKeys: String, CodingKey {
        case courseTitle, description, instructors
    }
}


struct Instructor: Codable, Identifiable {
    let id = UUID()
    let name: String
    let email: String
}

struct Subjects: Codable {
    let subjects: [Subject]
}


func loadJSON() -> [Subject] {
    guard let url = Bundle.main.url(forResource: "courses", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        return []
    }
    
    let decoder = JSONDecoder()
    do {
        let subjects = try decoder.decode(Subjects.self, from: data)
        return subjects.subjects
    } catch {
        print("Error decoding JSON: \(error)")
        return []
    }
}
