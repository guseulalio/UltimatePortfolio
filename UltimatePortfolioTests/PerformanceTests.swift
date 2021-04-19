//
//  PerformanceTests.swift
//  UltimatePortfolioTests
//
//  Created by Gustavo E M Cabral on 19/4/21.
//

//import CoreData
import XCTest
@testable import UltimatePortfolio

class PerformanceTests
: BaseTestCase
{
	func testAwardCalculationPerformance()
	throws
	{
		// Create a significant amount of sample data
		for _ in 1..<100
		{ try dataController.createSampleData() }
		
		// Simulate lots of awards to check
		let awards = Array(repeating: Award.allAwards, count: 25).joined()
		XCTAssertEqual(awards.count, 500, "This checks the number of awards is contant. Change this if you add new awards.")
		
		measure {
			_ = awards.filter(dataController.hasEarned)
		}
	}
}
