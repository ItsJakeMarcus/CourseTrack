//
//  CurrentCourses.swift
//  CourseTrack
//
//  Created by Jake Maidment on 16/06/2024.
//
import SwiftUI
import EffectsLibrary

struct DimmedBackgroundView: View {
    var body: some View {
        Color.black.opacity(0.66)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CurrentCourses: View {
    @Binding var enrolledCourses: [Course]
    @State private var showFireworks = false
    @State private var showDimmedBackground = false

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Image("Dotty")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(enrolledCourses) { course in
                            CourseGridItem(course: course, showFireworks: $showFireworks, showDimmedBackground: $showDimmedBackground)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Current Courses")
                
                // Dimmed background overlay
                if showDimmedBackground {
                    DimmedBackgroundView()
                        .transition(.opacity)
                }
                
                // Fireworks overlay
                if showFireworks {
                    FireworksView()
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                }
            }
        }
    }
}

struct CourseGridItem: View {
    @State private var badgeCount = 0
    let maxBadges = 5
    let badgeImage = "1hrBadge"
    let doneBadgeImage = "Done"
    let ydBadgeImage = "YD"
    let backgroundColors = [
        Color.red,
        Color.green,
        Color.yellow,
        Color.teal,
        Color.blue,
        Color.orange,
        Color.pink,
        Color.purple,
        Color.white,
        Color(UIColor.systemIndigo),
        Color(UIColor.systemGreen),
        Color(UIColor.systemPurple),
        Color(UIColor.systemOrange),
        Color(UIColor.systemPink),
        Color(UIColor.systemTeal),
        Color(UIColor.systemYellow),
        Color(UIColor.systemRed),
    ]

    var course: Course
    @State private var badgePositions: [Badge] = []
    @State private var doneBadgeAdded = false
    @State private var showYDBadge = false
    @Binding var showFireworks: Bool
    @Binding var showDimmedBackground: Bool
    struct Badge: Identifiable {
        let id = UUID()
        var imageName: String
        var position: CGPoint
        var rotation: Double
        var scale: CGFloat
    }

    func addBadge(imageName: String) {
        let badgeWidth: CGFloat = 30 * (imageName == doneBadgeImage ? 3.0 : CGFloat.random(in: 1.0...2.0))
        let badgeHeight: CGFloat = badgeWidth
        let minDistance: CGFloat = 40  // Minimum distance between badges

        var newPosition: CGPoint
        var validPosition: Bool

        repeat {
            let randomX = CGFloat.random(in: badgeWidth/2...170 - badgeWidth/2)
            let randomY = CGFloat.random(in: badgeHeight/2...180 - badgeHeight/2)
            newPosition = CGPoint(x: randomX, y: randomY)

            validPosition = true
            for badge in badgePositions {
                let distance = hypot(newPosition.x - badge.position.x, newPosition.y - badge.position.y)
                if distance < minDistance {
                    validPosition = false
                    break
                }
            }
        } while !validPosition

        let randomRotation = Double.random(in: -45...45)
        let newBadge = Badge(imageName: imageName, position: newPosition, rotation: randomRotation, scale: badgeWidth / 30)
        badgePositions.append(newBadge)
    }

    func addYDBadge() {
        showYDBadge = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showYDBadge = false
        }
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(course.courseTitle)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                Spacer()
            }
            .frame(width: 170, height: 180)
            .background(backgroundColors.randomElement()!)
            .cornerRadius(12)
            .shadow(radius: 3)

            GeometryReader { geometry in
                ZStack {
                    ForEach(badgePositions) { badge in
                        Image(badge.imageName)
                            .resizable()
                            .frame(width: 30 * badge.scale, height: 30 * badge.scale)
                            .rotationEffect(.degrees(badge.rotation))
                            .position(badge.position)
                    }
                    if showYDBadge {
                        Image(ydBadgeImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            .transition(.opacity)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .contextMenu {
            Button(action: {
                if badgeCount < maxBadges {
                    badgeCount += 1
                    addBadge(imageName: badgeImage)
                } else if !doneBadgeAdded {
                    doneBadgeAdded = true
                    addBadge(imageName: doneBadgeImage)
                } else {
                    addYDBadge()
                    showDimmedBackground = true
                    showFireworks = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                        showFireworks = false
                        showDimmedBackground = false
                    }
                }
            }) {
                if badgeCount < maxBadges {
                    Label("Add 1hr Badge", systemImage: "plus.circle.fill")
                } else if !doneBadgeAdded {
                    Label("Add Done Badge", systemImage: "checkmark.circle.fill")
                } else {
                    Label("You're done!", systemImage: "eye.fill")
                }
            }
        }
        .padding(.vertical, 5)
    }
}



struct CurrentCourses_Previews: PreviewProvider {
    static var previews: some View {
        CurrentCourses(enrolledCourses: .constant([]))
    }
}

