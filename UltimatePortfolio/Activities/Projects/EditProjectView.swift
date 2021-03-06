//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 12/3/21.
//

import SwiftUI

struct EditProjectView: View {
	@ObservedObject var project: Project
	
	@EnvironmentObject var dataController: DataController
	@Environment(\.presentationMode) var presentationMode
	
	@State private var title: String
	@State private var detail: String
	@State private var color: String
	@State private var showingDeleteConfirm = false
	
	let colorColumns = [GridItem(.adaptive(minimum: 44))]
	
	init(_ project: Project)
	{
		self.project = project
		
		_title = State(wrappedValue: project.projectTitle)
		_detail = State(wrappedValue: project.projectDetail)
		_color = State(wrappedValue: project.projectColor)
	}
	
    var body: some View {
        Form {
			Section(header: Text("Basic settings")) {
				TextField("Project name", text: $title.onChange(update))
				TextField("Description of this project", text: $detail.onChange(update))
			}
			
			Section(header: Text("Custom project color")) {
				LazyVGrid(columns: colorColumns) {
					ForEach(Project.colors, id: \.self, content: colorButton)
				}
				.padding(.vertical)
			}
			
			Section(footer: Text("CLOSE/DELETE PROJECT WARNING")) {
				Button(project.closed ? "Reopen this project" : "Close this project") {
					project.closed.toggle()
					update()
				}
				
				Button("Delete this project") {
					showingDeleteConfirm.toggle()
				}
				.accentColor(.red)
			}
		}
		.navigationTitle("Edit Project")
		.onDisappear(perform: dataController.save)
		.alert(isPresented: $showingDeleteConfirm)
		{
			Alert(title: Text("Delete project?"),
				  message: Text("Are you sure? You will also delete all the items it contains."),
				  primaryButton: .default(Text("Delete"), action: delete), secondaryButton: .cancel())
		}
    }
	
	/// Updates project object.
	func update()
	{
		project.title = title
		project.detail = detail
		project.color = color
	}
	
	/// Deletes project from DB.
	func delete()
	{
		dataController.delete(project)
		presentationMode.wrappedValue.dismiss()
	}
	
	/// Returns a button representing a color.
	/// - Parameter item: The name of the color.
	/// - Returns: The colored button.
	func colorButton(for item: String) -> some View
	{
		ZStack {
			Color(item)
				.aspectRatio(1, contentMode: .fit)
				.cornerRadius(6)
			
			if item == color {
				Image(systemName: "checkmark.circle")
					.foregroundColor(.white)
					.font(.largeTitle)
			}
		}
		.onTapGesture {
			color = item
			update()
		}
		.accessibilityElement(children: .ignore)
		.accessibilityAddTraits(
			item == color
				? [.isButton, .isSelected]
				: .isButton
		)
		.accessibilityLabel(LocalizedStringKey(item))
	}
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(Project.example)
    }
}
