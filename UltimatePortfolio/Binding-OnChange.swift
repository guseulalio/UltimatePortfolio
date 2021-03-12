//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 11/3/21.
//

import SwiftUI

extension Binding
{
	func onChange(_ handler: @escaping () -> Void) -> Binding<Value>
	{
		Binding(
			get: { self.wrappedValue },
			set:
			{ newValue in
				self.wrappedValue = newValue
				handler()
			}
		)
	}
}
