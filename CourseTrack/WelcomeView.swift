//
//  WelcomeView.swift
//  CourseTrack
//
//  Created by Jake Maidment on 16/06/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var navigateToContentView = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("Dotty")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("Logo")
                        .resizable()
                        .frame(width: 400, height: 400)
                        .offset(x: 15)
                        .padding()
                    
                    Spacer()
                }
                
                
                NavigationLink(destination: ContentView(), isActive: $navigateToContentView) {
                    EmptyView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigateToContentView = true
                }
            }
        }
    }
}


#Preview {
    WelcomeView()
}
