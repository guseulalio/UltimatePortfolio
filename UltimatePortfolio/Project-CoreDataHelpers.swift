//
//  Project-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 8/3/21.
//

import Foundation

extension Project
{
	var projectTitle: String { title ?? "New Project" }
	var projectDetail: String { detail ?? "" }
	var projectColor: String { color ?? "Light Blue" }
	
	var projectItems: [Item]
	{
		let itemsArray = items?.allObjects as? [Item] ?? []
		return itemsArray.sorted(by: itemSortCriteria)
	}
	
	var completionAmount: Double
	{
		let originalItems = items?.allObjects as? [Item] ?? []
		guard !originalItems.isEmpty else { return 0 }
		
		let completedItems = originalItems.filter(\.completed)
		return Double(completedItems.count) / Double(originalItems.count)
	}
	
	static var example: Project
	{
		let controller = DataController(inMemory: true)
		let dbContext = controller.container.viewContext
		
		let project = Project(context: dbContext)
		project.title = "Example Project"
		project.detail = "Detail of example project"
		project.closed = true
		project.creationDate = Date()
		return project
	}
	
	func itemSortCriteria(first: Item, second: Item) -> Bool
	{
		if !first.completed && second.completed { return true }
		else if first.completed && !second.completed { return false }
		
		if first.priority > second.priority { return true }
		else if first.priority < second.priority { return false }
		
		return first.itemCreationDate < second.itemCreationDate
	}
}
