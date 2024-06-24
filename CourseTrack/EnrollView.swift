//
//  EnrollView.swift
//  CourseTrack
//
//  Created by Jake Maidment on 16/06/2024.
//
import SwiftUI


struct EnrollView: View {
    @Binding var enrolledCourses: [Course]
    @State private var subjects: [Subject] = []
    @State private var showDino: Bool = false
    @State private var animatingStates: [Bool]
    @State private var animateSF = false
    

    init(enrolledCourses: Binding<[Course]>) {
        self._enrolledCourses = enrolledCourses
        self._animatingStates = State(initialValue: Array(repeating: false, count: loadJSON().count))
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 1) {
                    Text("Swipe to enroll")
                        .foregroundStyle(Color.secondary)
                        .bold()
                    
                    Image(systemName: "hand.point.up.left.and.text")
                        .foregroundStyle(Color.secondary)
                        .bold()
                        .offset(CGSize(width: 1.0, height: 2.0))
                        
                }
                List {
                    ForEach(subjects.indices, id: \.self) { index in
                        let subject = subjects[index]
                        Section(header: HStack {
                            Text(subject.subjectName)
                                .font(.title2)
                                .bold()
                                .padding(.vertical, 10)
                                .onTapGesture(count: 3) {
                                    if subject.subjectName == "History" {
                                        showDino = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            showDino = false
                                        }
                                    }
                                }
                            
                            if let (symbolName, color) = symbolAndColorForSubject(subject.subjectName) {
                                Image(systemName: symbolName)
                                    .font(.title2)
                                    .foregroundColor(color)
                                    .scaleEffect(animatingStates[index] ? 1.8 : 1.0)
                                    .animation(animatingStates[index] ? Animation.easeInOut(duration: 0.2) : .default)
                                    .onAppear {
                                        startAnimatingSymbols()
                                    }
                            }
                        }) {
                            ForEach(subject.courses.indices, id: \.self) { courseIndex in
                                NavigationLink(destination: CourseDetailView(course: subject.courses[courseIndex])) {
                                    VStack {
                                        Text(subject.courses[courseIndex].courseTitle)
                                            .font(.headline)
                                            .swipeActions {
                                                Button(action: {
                                                    updateEnrolledCourses(course: subject.courses[courseIndex])
                                                }) {
                                                    Label("Enroll", systemImage: "plus.circle.fill")
                                                }
                                                .tint(.green)
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .onAppear {
                    animateSF.toggle()
                    self.subjects = loadJSON()
                    self.animatingStates = Array(repeating: false, count: subjects.count)
                    startAnimatingSymbols()
                }
            }
            .background(Image("Dotty").resizable()
                .edgesIgnoringSafeArea(.all))
            .overlay(
                Group {
                    if showDino {
                        Image("Dino")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .transition(.opacity)
                    }
                }
            )
        }
    }

    private func startAnimatingSymbols() {
        for index in subjects.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                withAnimation {
                    animatingStates[index] = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        animatingStates[index] = false
                    }
                }
            }
        }
    }

    private func updateEnrolledCourses(course: Course) {
        if let index = subjects.firstIndex(where: { $0.courses.contains(where: { $0.id == course.id }) }) {
            if let courseIndex = subjects[index].courses.firstIndex(where: { $0.id == course.id }) {
                subjects[index].courses[courseIndex].isEnrolled = true
                enrolledCourses.append(subjects[index].courses[courseIndex])
            }
        }
    }

    private func symbolAndColorForSubject(_ subject: String) -> (String, Color)? {
        switch subject {
        case "Computer Science":
            return ("atom", .blue)
        case "Mathematics":
            return ("plusminus.circle", .orange)
        case "History":
            return ("shield.checkered", .red)
        case "Language Arts":
            return ("books.vertical.fill", .purple)
        case "Science":
            return ("testtube.2", .green)
        default:
            return nil
        }
    }
}




struct EnrollView_Previews: PreviewProvider {
    static var previews: some View {
        EnrollView(enrolledCourses: .constant([]))
    }
}

