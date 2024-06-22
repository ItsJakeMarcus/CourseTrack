//
//  ContentView.swift
//  CourseTrack
//
//  Created by Jake Maidment on 16/06/2024.
//
//TEST



import SwiftUI


struct ContentView: View {
    @State private var enrolledCourses: [Course] = []
    

    var body: some View {
        
        TabView {
            
            CurrentCourses(enrolledCourses: $enrolledCourses)
                .tabItem {
                    Label("Current Courses", systemImage: "list.bullet.rectangle")
                }
            
            EnrollView(enrolledCourses: $enrolledCourses)
                .tabItem {
                    Label("Enroll", systemImage: "graduationcap.fill")
                    
                    
                } 
        }
        .navigationBarBackButtonHidden(true)
        }
        
    
    
}



#Preview {
    ContentView()
}
