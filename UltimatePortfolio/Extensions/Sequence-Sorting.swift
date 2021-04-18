//
//  Sequance-Sorting.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 13/3/21.
//

import Foundation

extension Sequence
{
	/// Method created to allow sorting of sequences with objects that do not
	/// confirm to `Comparable`.
	/// - Parameters:
	///   - keyPath: key path indicating which property to use for comparison.
	///   - areInIncreasingOrder: closure with the sorting algorithm.
	/// - Throws: When there is an error in the comparison.
	/// - Returns: A sorted array of the elements in the original sequence.
	func sorted<Value> (by keyPath: KeyPath<Element, Value>, using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Element]
	{
		try self.sorted
		{
			try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
		}
	}
	
	func sorted<Value: Comparable> (by keyPath: KeyPath<Element, Value>) -> [Element]
	{
		self.sorted(by: keyPath, using: <)
	}
}
