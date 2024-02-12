//
//  AccountDetailView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AccountDetailView: View {
    @ObservedObject var viewModel: AccountDetailViewModel
    
    @State private var isShowingAllTransactions = false
    
    var body: some View {
        NavigationSplitView{
            NavigationLink(destination: AllTransactionsView(viewModel: AllTransactionViewModel()), isActive: $isShowingAllTransactions) { EmptyView() }
            VStack(spacing: 20) {
                // Large Header displaying total amount
                VStack(spacing: 10) {
                    Text("Your Balance")
                        .font(.headline)
                    Text(viewModel.totalAmount)
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(hex: "#94A684")) // Using the green color you provided
                    Image(systemName: "eurosign.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(Color(hex: "#94A684"))
                }
                .padding(.top)
                
                // Display recent transactions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Transactions")
                        .font(.headline)
                        .padding([.horizontal])
                    ForEach(viewModel.recentTransactions, id: \.label) { transaction in
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
                
                // Button to see details of transactions
                Button(action: {
                    // Implement action to show transaction details
                    isShowingAllTransactions = true
                }) {
                    HStack {
                        Image(systemName: "list.bullet")
                        Text("See Transaction Details")
                    }
                    .padding()
                    .background(Color(hex: "#94A684"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding([.horizontal, .bottom])
                
                Spacer()
            }
            .onTapGesture {
                self.endEditing(true)  // This will dismiss the keyboard when tapping outside
            }
            .onAppear{
                viewModel.loadRecentTransactions()
            }
        }detail: {
        
        }
        }
        
}

#Preview {
    AccountDetailView(viewModel: AccountDetailViewModel())
}
