//
//  ProjectsViewModel.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 19/4/21.
//

import CoreData
import Foundation

extension ProjectsView
{
	class ViewModel
	: NSObject, ObservableObject, NSFetchedResultsControllerDelegate
	{
		var dataController: DataController
		
		var sortOrder = Item.SortOrder.optimized
		let showClosedProjects: Bool
		
		private let projectsController: NSFetchedResultsController<Project>
		@Published var projects = [Project]()
		
		init(dataController: DataController, showClosedProjects: Bool = false)
		{
			self.showClosedProjects = showClosedProjects
			self.dataController = dataController
			
			let request: NSFetchRequest<Project> = Project.fetchRequest()
			request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
			request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)
			
			projectsController = NSFetchedResultsController(
				fetchRequest: request,
				managedObjectContext: dataController.container.viewContext,
				sectionNameKeyPath: nil, cacheName: nil)
			
			super.init()
			projectsController.delegate = self
			
			do {
				try projectsController.performFetch()
				projects = projectsController.fetchedObjects ?? []
			} catch {
				print("Failed to fetch our projects.")
			}
		}
		
		/// Creates a new empty project in the DB.
		func addProject()
		{
			let project = Project(context: dataController.container.viewContext)
			project.closed = false
			project.creationDate = Date()
			dataController.save()
		}
		
		/// Adds a new empty item to a project.
		/// - Parameter project: Project the item is going to be added to.
		func addItem(to project: Project)
		{
			let item = Item(context: dataController.container.viewContext)
			item.project = project
			item.creationDate = Date()
			dataController.save()
		}
		
		/// Delete a number of items from a project.
		/// - Parameters:
		///   - offsets: Items to be removed.
		///   - project: Project whose items will be removed.
		func delete(_ offsets: IndexSet, from project: Project)
		{
			let allItems = project.projectItems(using: sortOrder)
			for offset in offsets
			{
				let item = allItems[offset]
				dataController.delete(item)
			}
			dataController.save()
		}
		
		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
		{
			if let newProjects = controller.fetchedObjects as? [Project]
			{
				projects = newProjects
			}
		}
	}
}
