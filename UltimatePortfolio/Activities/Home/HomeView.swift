//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 8/3/21.
//

import CoreData
import SwiftUI

struct HomeView: View
{
	static let tag: String? = "Home"
	@StateObject var viewModel: ViewModel
	
	var projectRows: [GridItem] = [GridItem(.fixed(100))]
	
	init(dataController: DataController)
	{
		let viewModel = ViewModel(with: dataController)
		_viewModel = StateObject(wrappedValue: viewModel)
	}
	
    var body: some View {
        NavigationView {
			ScrollView {
				VStack(alignment: .leading) {
					ScrollView(.horizontal, showsIndicators: false) {
						LazyHGrid(rows: projectRows) {
							ForEach(viewModel.projects, content: ProjectSummaryView.init)
						}
						.padding([.horizontal, .top])
						.fixedSize(horizontal: false, vertical: true)
					}
					
					VStack(alignment: .leading) {
						ItemListView(title: "Up next", items: viewModel.upNext)
						ItemListView(title: "More to explore", items: viewModel.moreToExplore)
					}
					.padding(.horizontal)
				}
			}
			.background(Color.systemGroupedBackground.ignoresSafeArea())
			.navigationTitle("Home (Title)")
			.toolbar {
				Button("Add data", action: viewModel.addSampleData)
			}
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: DataController.preview)
    }
}
