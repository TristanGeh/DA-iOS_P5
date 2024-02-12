//
//  ChoiceView.swift
//  Aura
//
//  Created by Tristan Géhanne on 09/02/2024.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        if viewModel.isAuthenticated {
            AccountDetailView(viewModel: AccountDetailViewModel())
        } else {
            AuthenticationView(viewModel: viewModel)
        }
    }
}

#Preview {
    WelcomeView(viewModel: AuthenticationViewModel({}))
}
