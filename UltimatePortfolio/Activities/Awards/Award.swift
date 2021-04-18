//
//  Award.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 13/3/21.
//

import Foundation

/// An Award represents an achievement reached by the user.
struct Award
: Decodable, Identifiable
{
	var id: String { name }
	let name: String
	let description: String
	let color: String
	let criterion: String
	let value: Int
	let image: String
	
	static let allAwards = Bundle.main.decode([Award].self, from: "Awards.json")
	static let example = allAwards[0]
}
