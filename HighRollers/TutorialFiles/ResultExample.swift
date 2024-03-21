//
//  ResultExample.swift
//  HighRollers
//
//  Created by SCOTT CROWDER on 3/21/24.
//

import SwiftUI

struct ResultExample: View {
    
    enum NetworkError: Error {
        case badURL
    }
    
    @State private var networkResult: Result<String, NetworkError>?
    
    var body: some View {
        Form{
            Section("Network Test"){
                Button("Test Network") {
                    networkResult = createResult()
                }
                .buttonStyle(.borderedProminent)
                VStack(alignment: .leading){
                    Text("Network result: ")
                        .font(.headline) +
                    Text("\(networkResult ?? Result.success("N/A"))")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .border(.black)
            }
        }
    }
    
    func createResult() -> Result<String, NetworkError> {
        if Bool.random() {
            return .success("Network test succeeded")
        } else {
            return .failure(.badURL)
        }
        
    }
}

#Preview {
    ResultExample()
}
