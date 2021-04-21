//
//  HomeViewModel.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 19/4/21.
//

import CoreData
import Foundation

extension HomeView
{
	class ViewModel
	: NSObject, ObservableObject, NSFetchedResultsControllerDelegate
	{
		private let projectsController: NSFetchedResultsController<Project>
		private let itemsController: NSFetchedResultsController<Item>
		
		@Published var projects = [Project]()
		@Published var items = [Item]()
		
		var dataController: DataController
		
		var upNext: ArraySlice<Item> {
			items.prefix(3)
		}
		
		var moreToExplore: ArraySlice<Item> {
			items.dropFirst(3)
		}
		
		init(with dataController: DataController)
		{
			self.dataController = dataController
			
			// Construct fetch request to show all projects
			let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
			projectRequest.predicate = NSPredicate(format: "closed = false")
			projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
			
			projectsController = NSFetchedResultsController(
				fetchRequest: projectRequest,
				managedObjectContext: dataController.container.viewContext,
				sectionNameKeyPath: nil, cacheName: nil)
			
			// Construct a fetch request to show 10 highest priority, incomplete
			// items from open projects.
			let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
			
			let incompletePredicate = NSPredicate(format: "completed = false")
			let openPredicate = NSPredicate(format: "project.closed = false")
			let compountPredicate = NSCompoundPredicate(type: .and, subpredicates: [incompletePredicate, openPredicate])
			itemRequest.predicate = compountPredicate
			itemRequest.sortDescriptors = [ NSSortDescriptor(keyPath: \Item.priority, ascending: false) ]
			itemRequest.fetchLimit = 10
			
			itemsController = NSFetchedResultsController(
				fetchRequest: itemRequest,
				managedObjectContext: dataController.container.viewContext,
				sectionNameKeyPath: nil, cacheName: nil)
			
			super.init()
			projectsController.delegate = self
			itemsController.delegate = self
			
			do {
				try projectsController.performFetch()
				try itemsController.performFetch()
				
				projects = projectsController.fetchedObjects ?? []
				items = itemsController.fetchedObjects ?? []
			} catch {
				print("Failed to fetch initial data.")
			}
			
		}
		
		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			if let newItems = controller.fetchedObjects as? [Item]
			{ items = newItems }
			else if let newProjects = controller.fetchedObjects as? [Project]
			{ projects = newProjects }
		}
		
		/// Doesn't really just "add" sample data. Deletes everything then adds the data.
		func addSampleData()
		{
			dataController.deleteAll()
			try? dataController.createSampleData()
		}
	}
}
