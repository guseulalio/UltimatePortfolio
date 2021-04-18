//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 8/3/21.
//

import SwiftUI

struct ProjectsView: View {
	static let openTag: String? = "Open"
	static let closedTag: String? = "Closed"
	
	@EnvironmentObject var dataController: DataController
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@State private var showingSortOrder = false
	@State private var sortOrder = Item.SortOrder.optimized
	
	let showClosedProjects: Bool
	
	let projects: FetchRequest<Project>
	
	init(showClosedProjects: Bool = false)
	{
		self.showClosedProjects = showClosedProjects
		
		projects = FetchRequest<Project>(
			entity: Project.entity(),
			sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)],
			predicate: NSPredicate(format: "closed = %d", showClosedProjects)
		)
	}
	
    var body: some View {
        NavigationView {
			Group {
				if projects.wrappedValue.isEmpty {
					Text("There's nothing here right now")
					.foregroundColor(.secondary)
				} else {
					projectsList
				}
			}
			.navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
			.toolbar
			{
				addProjectToolbarItem
				sortOrderToolbarItem
			}
			.actionSheet(isPresented: $showingSortOrder)
			{
				ActionSheet(title: Text("Sort items"), message: nil, buttons: [
								.default(Text("Optimized")) { sortOrder = .optimized },
								.default(Text("Creation Date")) { sortOrder = .creationDate },
								.default(Text("Title")) { sortOrder = .title }])
			}
			
			SelectSomethingView()
		}
    }
	
	var projectsList: some View {
		List {
			ForEach(projects.wrappedValue)
			{ project in
				Section(header: ProjectHeaderView(project: project)) {
					ForEach(project.projectItems(using: sortOrder))
						{ item in ItemRowView(project: project, item: item) }
						.onDelete { offsets in delete(offsets, from: project) }
					
					if !showClosedProjects
					{
						Button { addItem(to: project) }
							label: { Label("Add New Item", systemImage: "plus") }
					}
				}
			}
		}
		.listStyle(InsetGroupedListStyle())
	}
	
	/// Button to add new project.
	var addProjectToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing)
		{
			if !showClosedProjects
			{
				Button(action: addProject)
				{
					// In iOS 14.3, VoiceOver has a glitch that reads the label
					// "Add Project" as "Add" no matter what accessibility label
					// we give this toolbar button when using a Label.
					// As a result, when VoiceOver is running, we use a text view
					// for the button instead, forging a correct reading without
					// losing the original layout.
					if UIAccessibility.isVoiceOverRunning {
						Text("Add Project")
					} else {
						Label("Add Project", systemImage: "plus")
					}
				}
			}
		}
	}
	
	/// Button to sort list of projects.
	var sortOrderToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading)
		{
			Button { showingSortOrder.toggle() }
				label: { Label("Sort", systemImage: "arrow.up.arrow.down")}
		}
	}
	
	/// Creates a new empty project in the DB.
	func addProject()
	{
		withAnimation {
			let project = Project(context: managedObjectContext)
			project.closed = false
			project.creationDate = Date()
			dataController.save()
		}
	}
	
	/// Adds a new empty item to a project.
	/// - Parameter project: Project the item is going to be added to.
	func addItem(to project: Project)
	{
		withAnimation {
			let item = Item(context: managedObjectContext)
			item.project = project
			item.creationDate = Date()
			dataController.save()
		}
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
}

struct ProjectsView_Previews: PreviewProvider {
	static var dataController = DataController.preview
	
    static var previews: some View {
        ProjectsView()
			.environment(\.managedObjectContext, dataController.container.viewContext)
			.environmentObject(dataController)
    }
}
