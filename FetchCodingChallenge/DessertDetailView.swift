//
//  DesertDetailView.swift
//  SwiftUILearningFromUIKit
//
//  Created by Joseph Barbosa on 3/7/24.
//

import SwiftUI

struct DessertDetailView: View {
    @ObservedObject var viewModel = DessertDetailViewModel()
    
    let dessertId: String
    init(dessertId: String) {
        self.dessertId = dessertId
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Text(viewModel.dessertDetails?.strMeal ?? "")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                if let urlString = viewModel.dessertDetails?.strMealThumb, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        default:
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Instructions")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Text(viewModel.dessertDetails?.strInstructions ?? "")
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Ingredients")
                        .font(.headline)
                    ForEach(viewModel.dessertDetails?.ingredients ?? [], id: \.self) { item in
                        HStack {
                            Text("•")
                            Text("\(item.name) (\(item.measurement))")
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding([.leading, .trailing], 30)
        }.task {
            await viewModel.fetchDessertDetails(for: dessertId)
        }.alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK")) { }
            )
        }
    }
}
