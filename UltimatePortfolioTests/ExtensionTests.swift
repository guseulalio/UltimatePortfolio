//
//  ExtensionTests.swift
//  UltimatePortfolioTests
//
//  Created by Gustavo E M Cabral on 19/4/21.
//

import SwiftUI
import XCTest
@testable import UltimatePortfolio

class ExtensionTests
: XCTestCase
{
	struct MyType: Equatable
	{
		var number: Int
		var text: String
	}
	
	func testSequenceKeyPathSortingSelf()
	{
		let items = [1, 4, 3, 2, 5]
		let sortedItems = items.sorted(by: \.self)
		XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "The sorted numbers must be ascending.")
	}
	
	func testSequenceKeyPathSortingCustom()
	{
		let items = [
			MyType(number: 5, text: "Aardvark"), MyType(number: 1, text: "Bobcat"),
			MyType(number: 16, text: "Zebra"), MyType(number: 3, text: "Anteater"),
			MyType(number: 2, text: "Quokka")
		]
		
		let sortedByNumber = items.sorted(by: \.number, using: <)
		let sortedByText = items.sorted(by: \.text, using: <)
		
		XCTAssertEqual(sortedByNumber, [
			MyType(number: 1, text: "Bobcat"), MyType(number: 2, text: "Quokka"),
			MyType(number: 3, text: "Anteater"), MyType(number: 5, text: "Aardvark"),
			MyType(number: 16, text: "Zebra"),
		])
		XCTAssertEqual(sortedByText, [
			MyType(number: 5, text: "Aardvark"), MyType(number: 3, text: "Anteater"),
			MyType(number: 1, text: "Bobcat"), MyType(number: 2, text: "Quokka"),
			MyType(number: 16, text: "Zebra"),
		])
	}
	
	func testBundleDecodingAwards()
	{
		let awards = Bundle.main.decode([Award].self, from: "Awards.json")
		XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array.")
	}
	
	func testDecodingString()
	{
		let bundle = Bundle(for: ExtensionTests.self)
		let data = bundle.decode(String.self, from: "DecodableString.json")
		
		XCTAssertEqual(data, "The rain in Spain falls mainly on the Spaniards.",
					   "The string must match the content of DecodableString.json.")
	}
	
	func testDecodingDictionary()
	{
		let bundle = Bundle(for: ExtensionTests.self)
		let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
		
		XCTAssertEqual(data.count, 3, "There should be 3 items decoded from DecodableDictionary.json.")
		XCTAssertEqual(data["One"], 1, "Item for key \"One\" should return 1.")
		XCTAssertEqual(data["Two"], 2, "Item for key \"Two\" should return 2.")
		XCTAssertEqual(data["Three"], 3, "Item for key \"Three\" should return 3.")
	}
	
	func testBindingOnChange()
	{
		// Given
		var onChangeFunctionRun = false
		
		func exampleFunctionToCall() { onChangeFunctionRun = true }
		
		var storedValue = ""
		
		let binding = Binding(
			get: { storedValue },
			set: { storedValue = $0 }
		)
		
		// When
		let changedBinding = binding.onChange(exampleFunctionToCall)
		
		// Then
		changedBinding.wrappedValue = "Test"
		XCTAssertTrue(onChangeFunctionRun, "The onChange() function must be run when the binding is changed.")
	}
}
