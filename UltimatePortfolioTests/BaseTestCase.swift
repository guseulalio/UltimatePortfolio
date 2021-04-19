//
//  BaseTestCase.swift
//  BaseTestCase
//
//  Created by Gustavo E M Cabral on 18/4/21.
//

import CoreData
import XCTest
@testable import UltimatePortfolio

class BaseTestCase
: XCTestCase
{
	var dataController: DataController!
	var managedObjectContext: NSManagedObjectContext!
	
	override func setUpWithError() throws
	{
		dataController = DataController(inMemory: true)
		managedObjectContext = dataController.container.viewContext
	}
}
