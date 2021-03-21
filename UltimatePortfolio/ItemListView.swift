//
//  ItemListView.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 21/3/21.
//

import CoreData
import SwiftUI

struct ItemListView: View {
	var title: LocalizedStringKey
	let items: FetchedResults<Item>.SubSequence
	
    var body: some View {
		if items.isEmpty { EmptyView() }
		else {
			Text(title)
				.font(.headline)
				.foregroundColor(.secondary)
				.padding(.top)
			
			ForEach(items)
			{item in
				NavigationLink(destination: EditItemView(item: item)) {
					HStack(spacing: 20) {
						Circle()
							.stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
							.frame(width: 44, height: 44)
						
						VStack(alignment: .leading) {
							Text(item.itemTitle)
								.font(.title2)
								.frame(maxWidth: .infinity, alignment: .leading)
								.foregroundColor(.primary)
							
							if !item.itemDetail.isEmpty
							{
								Text(item.itemDetail)
									.foregroundColor(.secondary)
							}
						}
					}
					.padding()
					.background(Color.secondarySystemGroupedBackground)
					.cornerRadius(10)
					.shadow(color: Color.black.opacity(0.2), radius: 5)
				}
			}
		}
    }
}

//struct ItemListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemListView()
//    }
//}