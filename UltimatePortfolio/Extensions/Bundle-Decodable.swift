//
//  Bundle-Decodable.swift
//  UltimatePortfolio
//
//  Created by Gustavo E M Cabral on 13/3/21.
//

import Foundation

extension Bundle
{
	/// Decodes an object from a JSON file
	/// - Parameters:
	///   - type: Type of object to be that will be returned.
	///   - file: path of JSON file in `String` format. Contents from JSON file must match the returned object's structure.
	///   - dateDecodingStrategy: Strategy for decoding the date strings.
	///   - keyDecodingStrategy: Strategy for interpreting keys.
	/// - Returns: Object of type `type` decoded from the JSON file.
	func decode<T: Decodable>(
		_ type: T.Type,
		from file: String,
		dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
		keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
		) -> T
	{
		guard let url = self.url(forResource: file, withExtension: nil)
		else { fatalError("Failed to locate \(file) in bundle.") }
		
		guard let data = try? Data(contentsOf: url)
		else { fatalError("Failed to load \(file) from bundle.") }
		
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = dateDecodingStrategy
		decoder.keyDecodingStrategy = keyDecodingStrategy
		
		do { return try decoder.decode(T.self, from: data) }
		catch DecodingError.keyNotFound(let key, let context)
		{ fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' -- \(context.debugDescription)") }
		catch DecodingError.typeMismatch(_, let context)
		{ fatalError("Failed to decode \(file) from bundle due to type mismatch -- \(context.debugDescription)") }
		catch DecodingError.valueNotFound(let type, let context)
		{ fatalError("Failed to decode \(file) from bundle due to missing \(type) value -- \(context.debugDescription)") }
		catch DecodingError.dataCorrupted(let context)
		{ fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON -- \(context.debugDescription)") }
		catch
		{ fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)") }
	}
}