//
//  HigherOrderFunctionsExample.swift
//  HighRollers
//
//  Created by SCOTT CROWDER on 3/21/24.
//

import SwiftUI

struct HigherOrderFunctionsExample: View {
    
    let numbers: [Int] = [1, 2, 3, 4, 5]
    @State private var evens: [Int] = [Int]()
    
    let stringNumbers: [String] = ["1", "2", "fish", "3"]
    @State private var evensMap: [Int?] = [Int?]()
    @State private var evensCompactMap: [Int] = [Int]()
    
    var body: some View {
        Form {
            Section(".filter()"){
                Text("Numbers Array: \(numbers)")
                Text("Evens: \(evens)")
                
                Button("Filter Numbers") {
                    evens = numbers.filter { $0.isMultiple(of: 2) }
                }
                .buttonStyle(.borderedProminent)
            }
            
            Section(".map() & .compactMap()") {
                Text("String Numbers: \(stringNumbers)")
                Text(".map() = \(evensMap)")
                Text(".compactMap() = \(evensCompactMap)")
                Button("Map and CompactMap") {
                    evensMap = stringNumbers.map(Int.init)
                    evensCompactMap = stringNumbers.compactMap(Int.init)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    HigherOrderFunctionsExample()
}
