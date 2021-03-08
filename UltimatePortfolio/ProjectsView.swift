//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 8/3/21.
//

import SwiftUI

struct ProjectsView: View {
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
			List {
				ForEach(projects.wrappedValue)
				{ project in
					Section(header: Text(project.title ?? "")) {
						ForEach(project.items?.allObjects as? [Item] ?? [])
						{ item in
							Text(item.title ?? "")
						}
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle(showClosedProjects ? "Closed projects" : "Open projects")
		}
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
