//
//  AllTransactionsView.swift
//  Aura
//
//  Created by Tristan Géhanne on 12/02/2024.
//

import SwiftUI

struct AllTransactionsView: View {
    @ObservedObject var viewModel: AllTransactionViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("All Transactions :")
                    .font(.headline)
                    .padding([.horizontal])
                    Spacer()
                ForEach(viewModel.allTransactions, id: \.label) { transaction in
                    HStack {
                        Image(systemName: transaction.value > Decimal(0) ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                            .foregroundColor(transaction.value > Decimal(0) ? Color.green : Color.red)
                        Text(transaction.label)
                        Spacer()
                        Text("\(transaction.value.description)")
                            .fontWeight(.bold)
                            .foregroundColor(transaction.value > Decimal(0) ? Color.green : Color.red)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding([.horizontal])
                }
            }
            .onAppear{
                viewModel.loadAllTransactions()
        }
        }
    }
}

#Preview {
    AllTransactionsView(viewModel: AllTransactionViewModel())
}
