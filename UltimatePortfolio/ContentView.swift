//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 7/3/21.
//

import SwiftUI

struct ContentView: View {
	@AppStorage("selectedView") var selectedView: String?
	
    var body: some View {
		TabView(selection: $selectedView)
		{
			HomeView()
			.tag(HomeView.tag)
			.tabItem { Image(systemName: "house"); Text("Home")}
			
			ProjectsView(showClosedProjects: false)
			.tag(ProjectsView.openTag)
			.tabItem { Image(systemName: "list.bullet"); Text("Open") }
			
			ProjectsView(showClosedProjects: true)
			.tag(ProjectsView.closedTag)
			.tabItem { Image(systemName: "checkmark"); Text("Closed") }
			
			AwardsView()
			.tag(AwardsView.tag)
			.tabItem { Image(systemName: "rosette"); Text("Awards") }
		}
    }
}

struct ContentView_Previews: PreviewProvider {
	static var dataController = DataController.preview
	
    static var previews: some View {
        ContentView()
			.environment(\.managedObjectContext, dataController.container.viewContext)
			.environmentObject(dataController)
    }
}
