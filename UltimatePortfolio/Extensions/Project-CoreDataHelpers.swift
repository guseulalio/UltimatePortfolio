//
//  Project-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 8/3/21.
//

import SwiftUI

extension Project
{
	static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
	
	var projectTitle: String { title ?? NSLocalizedString("New Project", comment: "New project's title") }
	var projectDetail: String { detail ?? "" }
	var projectColor: String { color ?? "Light Blue" }
	
	var projectItems: [Item]
	{
		items?.allObjects as? [Item] ?? []
	}
	
	var projectItemsDefaultSorted: [Item]
	{ return projectItems.sorted(by: itemDefaultSortCriteria) }
	
	func itemDefaultSortCriteria(first: Item, second: Item) -> Bool
	{
		if !first.completed && second.completed { return true }
		else if first.completed && !second.completed { return false }
		
		if first.priority > second.priority { return true }
		else if first.priority < second.priority { return false }
		
		return first.itemCreationDate < second.itemCreationDate
	}
	
	var completionAmount: Double
	{
		let originalItems = items?.allObjects as? [Item] ?? []
		guard !originalItems.isEmpty else { return 0 }
		
		let completedItems = originalItems.filter(\.completed)
		return Double(completedItems.count) / Double(originalItems.count)
	}
	
	var label: LocalizedStringKey {
		LocalizedStringKey("\(projectTitle), \(projectItems.count) items, \(completionAmount * 100, specifier: "%g")% complete")
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
	
	func projectItems(using sortOrder: Item.SortOrder) -> [Item]
	{
		switch sortOrder
		{
			case .title: return projectItems.sorted(by: \Item.itemTitle)
			case .creationDate: return projectItems.sorted(by: \Item.itemCreationDate)
			default: return projectItemsDefaultSorted
		}
	}
}
