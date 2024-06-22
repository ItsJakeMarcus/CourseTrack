//
//  CourseDetailView.swift
//  CourseTrack
//
//  Created by Jake Maidment on 16/06/2024.
//

import SwiftUI

struct CourseDetailView: View {
    var course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(course.courseTitle)
                .font(.largeTitle)
                .bold()
            
            Text(course.description)
                .font(.body)
            
            Text("Instructors")
                .font(.title2)
                .bold()
            
            ForEach(course.instructors) { instructor in
                VStack(alignment: .leading) {
                    Text(instructor.name)
                        .font(.headline)
                    Text(instructor.email)
                        .font(.subheadline)
                }
                .padding(.vertical, 2)
            }
            
            if course.isEnrolled {
                Capsule()
                    .stroke(Color.green, lineWidth: 2)
                    .frame(width: 85, height: 30)
                    .overlay(
                        Text("Enrolled")
                            .foregroundColor(.green)
                            .font(.headline)
                    )
            }
            
            Spacer()
        }
        .padding()
        //.navigationTitle(course.courseTitle)
    }
}


struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        if let firstCourse = loadJSON().first?.courses.first {
            CourseDetailView(course: firstCourse)
        } else {
            Text("No Course Data Available")
        }
    }
}

