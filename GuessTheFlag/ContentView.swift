//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Leo Torres Neyra on 3/10/23.
//

import SwiftUI

struct FlagImage: View {
    var number: Int
    var countries: [String]
    
    var body: some View {
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct WithTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
    }
}

extension View {
    func changeTitle () -> some View {
        modifier(WithTitle())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showFinalScore = false
    @State private var scoreTitle = ""
    @State private var finalScoreTitle = "END OF THE GAME 👾"
    @State private var scoreCount = 0
    @State private var gameCount = 0
    @State private var restartGame = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var animationAmount = 1.0
    
    @State private var isTapped = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Guess the Flag")
                    .changeTitle()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button {
                            flagTapped(number)
                            withAnimation{
                                animationAmount += 1
                                /*
                                 if isTapped {
                                 rotation3DEffect(.degrees(animationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
                                 }else {
                                 Animation.easeInOut(duration: 1).repeatCount(3).animate(value: animationAmount)
                                 }*/
                            }
                        } label: {
                            FlagImage(number: number, countries: countries)
                        }
                        //.rotation3DEffect(.degrees(animationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
                        //.animation(.default, value: animationAmount)
                        //.scaleEffect(animationAmount)
                        //                        .animation(
                        //                            .easeInOut(duration: 1)
                        //                            .repeatCount(3), value: animationAmount
                        //                        )
                        
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(scoreCount)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        /*
         .alert(scoreTitle, isPresented: $showingScore) {
         Button("Continue", action: askQuestion)
         } message: {
         Text("Your score is \(scoreCount)")
         }
         .alert(scoreTitle, isPresented: $showFinalScore) {
         Button("Continue"){ restartGame = true }
         } message: {
         Text("Your score is \(scoreCount)")
         }
         .alert(finalScoreTitle, isPresented: $restartGame){
         Button("Continue", action: reset)
         } message: {
         Text("Your final score is \(scoreCount)")
         }
         */
    }
    
    func flagTapped (_ number: Int) {
        gameCount += 1
        isTapped = true
        
        if number == correctAnswer {
            isTapped = true
            scoreCount += 1
            scoreTitle = "CORRECT!"
        }else {
            isTapped = false
            scoreTitle = "WRONG!, That's the flag of " + countries[number]
        }
        
        if gameCount == 5 {
            showingScore = false
            showFinalScore = true
            return
        }
        
        showingScore = true
    }
    
    func askQuestion () {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isTapped = false
    }
    
    func reset() {
        scoreCount = 0
        gameCount = 0
        countries.shuffle()
        isTapped = false
    }
}

#Preview {
    ContentView()
}
