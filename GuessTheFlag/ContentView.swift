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
    var rotateAmount: Double
    var opacityAmount: Double
    var scaleAmount: Double
    
    var body: some View {
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .opacity(opacityAmount)
            .scaleEffect(scaleAmount)
            .rotation3DEffect(.degrees(Double(rotateAmount)),
                              axis: (x: 0.0, y: 1.0, z: 0.0))
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
    @State private var correctAnswer = Int.random(in: 0...3)
    
    @State private var isTapped = -1
    
    @State private var rotateAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var scaleAmount = 1.0
    
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
                
                VStack(spacing: 20) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<4, id: \.self){ number in
                        Button {
                            flagTapped(number)
                            withAnimation(.spring(duration: 1, bounce: 0.5)) {
                                rotateAmount += 360
                            }
                            withAnimation() {
                                opacityAmount -= 0.55
                                scaleAmount -= 0.3
                            }
                        } label: {
                            FlagImage(number: number, countries: countries,rotateAmount: (isTapped == number ? rotateAmount : 0),
                                      opacityAmount: (isTapped == number ? 1 : opacityAmount),
                                      scaleAmount: (isTapped == number ? 1 : scaleAmount))
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))

                
                Spacer()
                Spacer()
                
                Text("Score: \(scoreCount)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        
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
            Button("Continue"){
                askQuestion()
                reset()
            }
        } message: {
            Text("Your final score is \(scoreCount)")
        }
        
    }
    
    func flagTapped (_ number: Int) {
        gameCount += 1
        isTapped = number
        
        if number == correctAnswer {
            scoreCount += 1
            scoreTitle = "CORRECT!"
        }else {
            scoreTitle = "WRONG!, That's the flag of " + countries[number].uppercased()
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
        correctAnswer = Int.random(in: 0...3)
        rotateAmount = 0.0
        opacityAmount = 1.0
        scaleAmount = 1.0
        isTapped = -1
    }
    
    func reset() {
        gameCount = 0
        scoreCount = 0
    }
}

#Preview {
    ContentView()
}
