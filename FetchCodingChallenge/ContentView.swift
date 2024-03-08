//
//  ContentView.swift
//  SwiftUILearningFromUIKit
//
//  Created by Joseph Barbosa on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            } else {
                NavigationView {
                    List(viewModel.desserts) { item in
                        NavigationLink(destination: DessertDetailView(dessertId: item.id)) {
                            Text(item.strMeal)
                        }
                    }.navigationTitle("Desserts")
                }
            }
        }.task {
            await viewModel.fetchDesserts()
        }.alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK")) { }
            )
        }
    }
}

#Preview {
    ContentView()
}
