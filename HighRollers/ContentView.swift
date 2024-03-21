//
//  ContentView.swift
//  HighRollers
//
//  Created by SCOTT CROWDER on 3/21/24.
//

import Combine
import SwiftUI

struct ContentView: View {
    
    struct Roll: Codable, Identifiable {
        let id: UUID
        let firstDie: Int
        let secondDie: Int
        
        init(firstDie: Int, secondDie: Int) {
            self.id = UUID()
            self.firstDie = firstDie
            self.secondDie = secondDie
        }
    }
    
    let sides: [Int] = [4, 6, 10, 20, 100]
    
    @State private var pickedSides: Int = 4
    @State private var result: [Int] = [0, 0]
    @State private var total: Int = 0
    
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.25, on: .main, in: .common)
    @State private var timerCancellable: Cancellable?
    @State private var ellapsedTime: Double = 0.0
    
    @State private var isShowingAlert: Bool = false
    
    @AppStorage("rolls") private var rollsData: Data = Data()
    @State private var rolls: [Roll] = [] {
        didSet {
            rollsData = encodeData(rolls) ?? Data()
        }
    }
    
    init() {
        if let decodedData = decodeData(rollsData) {
            _rolls = State(initialValue: decodedData)
        }
        _pickedSides = State(initialValue: sides.randomElement()!)
    }
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading){
                    Text("Number of Dice Sides")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                    Picker("Sides", selection: $pickedSides) {
                        ForEach(sides, id: \.self) { side in
                            Text("\(side)")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Button("Roll Dice!") {
                    rollDice()
                }
                .buttonStyle(.borderedProminent)
            }
            Section("Result") {
                Text("Total: \(result[0]) + \(result[1]) = \(total)")
                    .font(.title)
                HStack {
                    DiceView(die1: result[0], die2: result[1])
                }
            }
            Section("All Results") {
                Button("Clear All Results", systemImage: "trash") {
                    isShowingAlert = true
                }
                ForEach(rolls) { roll in
                    DiceView(die1: roll.firstDie, die2: roll.secondDie)
                }
                .onDelete(perform: deleteRoll)
            }
        }
        .sensoryFeedback(.success, trigger: total)
        .disabled(ellapsedTime > 0)
        .alert("WARNING", isPresented: $isShowingAlert) {
            Button("OK", role: .destructive){
                rolls = []
            }
            Button("CANCEL", role: .cancel) {}
        } message: {
            Text("This will remove all previous results. Do you want to continue?")
        }
    }
    
    func deleteRoll(for offsets: IndexSet) {
        rolls.remove(atOffsets: offsets)
    }
    
    func encodeData(_ data: [Roll]) -> Data? {
        return try? JSONEncoder().encode(data)
    }
    
    func decodeData(_ data: Data) -> [Roll]? {
        return try? JSONDecoder().decode([Roll].self, from: data)
    }
    
    func rollDice() {
        ellapsedTime = 0.0
        result = [0, 0]
        
        timerCancellable = timer.autoconnect().sink { _ in
            ellapsedTime += 0.25
            result = (1...2).map { _ in Int.random(in: 1...pickedSides) }
            total = result[0] + result[1]
            if ellapsedTime >= 2 {
                timerCancellable?.cancel()
                ellapsedTime = 0.0
                saveRoll()
            }
        }
    }
    
    func saveRoll() {
        let newRoll: Roll = Roll(firstDie: result[0], secondDie: result[1])
        rolls.append(newRoll)
    }
}

#Preview {
    ContentView()
}

struct DieView: View {
    
    let value: Int
    
    var body: some View {
        Text("\(value)")
            .frame(width: 75, height: 75)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(.black)
            .background(.white)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 3)
            .font(.title)
            .padding(5)
    }
}

struct DiceView: View {
    
    let die1: Int
    let die2: Int
    
    var body: some View {
        
        HStack {
            Spacer()
            DieView(value: die1)
            Divider()
                .padding(.horizontal, 20)
            DieView(value: die2)
            Spacer()
        }
    }
}
