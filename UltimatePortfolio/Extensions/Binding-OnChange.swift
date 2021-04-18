//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 11/3/21.
//

import SwiftUI

extension Binding
{
	/// Allows the execition of code on the change event of a `Binding`.
	/// - Parameter handler: code to execute on change event.
	/// - Returns: a `Binding` that wraps the original one and responds to the change event.
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
