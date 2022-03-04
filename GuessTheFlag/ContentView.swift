//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Derya Antonelli on 21/01/2022.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.semibold))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct FlagImage: View {
    var image: Image
    
    var body: some View {
        image
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameOver = false
    @State private var totalNumberOfQuestions = 8
    @State private var numberOfQuestionsAsked = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var rotationAmount = [0.0, 0.0, 0.0]
    @State private var opacityAmount = [1.0, 1.0, 1.0]
    @State private var scaleAmount = [1.0, 1.0, 1.0]

    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.3), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
            VStack {
                    Spacer()
                    Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .titleStyle()
                        }
                    ForEach(0..<3) { number in
                            Button {
                                flagTapped(number)
                                rotationAmount[number] += 360
                                for index in 0..<3 where index != number {
                                    opacityAmount[index] -= 0.5
                                    scaleAmount[index] -= 1.0
                                }
                            } label: {
                                FlagImage(image: Image(countries[number]))
                            }
                            .scaleEffect(scaleAmount[number])
                            .opacity(opacityAmount[number])
                            .animation(.default, value: opacityAmount[number])
                            .rotation3DEffect(.degrees(rotationAmount[number]), axis: (x: 0.0, y: 1.0, z: 0.0))
                            .animation(.default, value: rotationAmount[number])
                        }
                    
                }

            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert(scoreTitle, isPresented: $gameOver) {
            Button("Restart", action: restartGame)
        } message: {
            Text("Your total score is \(score)")
        }
            

    }
    
    func flagTapped(_ number: Int) {
        if(number == correctAnswer) {
            scoreTitle = "Correct"
            score += 5
        } else {
            scoreTitle = "Dang! That's the flag of \(countries[number])"
        }
        
        numberOfQuestionsAsked += 1
        
        if(numberOfQuestionsAsked == totalNumberOfQuestions ) {
            gameOver = true
            scoreTitle = "Game Over"
        }
        else {
            showingScore = true
        }
    }
    
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityAmount = [1.0, 1.0, 1.0]
        scaleAmount = [1, 1, 1]
    }
    
    func restartGame() {
        numberOfQuestionsAsked = 0
        score = 0
        askQuestion()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
