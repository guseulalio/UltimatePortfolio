//
//  SelectSomethingView.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 13/3/21.
//

import SwiftUI

/// View that is shown on landscape mode to remind the use that s/he can select
/// from the menu.
struct SelectSomethingView: View {
    var body: some View {
        Text("Please select something from the menu to begin.")
		.italic()
		.foregroundColor(.secondary)
    }
}

struct SelectSomethingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomethingView()
    }
}
