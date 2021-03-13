//
//  Items-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 8/3/21.
//

import Foundation

extension Item
{
	enum SortOrder { case optimized, title, creationDate }
	
	var itemTitle: String { title ?? "New Item" }
	var itemDetail: String { detail ?? "" }
	var itemCreationDate: Date { creationDate ?? Date() }
	
	static var example: Item
	{
		let controller = DataController(inMemory: true)
		let dbContext = controller.container.viewContext
		
		let item = Item(context: dbContext)
		item.title = "Example item"
		item.detail = "This is an example item."
		item.priority = 3
		item.creationDate = Date()
		return item
	}
}
