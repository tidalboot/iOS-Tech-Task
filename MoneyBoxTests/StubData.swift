//
//  StubData.swift
//  MoneyBoxTests
//
//  Created by Zeynep Kara on 17.01.2022.
//

import Foundation
@testable import MoneyBox

struct StubData {
    static func read<V: Decodable>(file: String, callback: @escaping (Result<V, Error>) -> Void) {
        if let path = Bundle.main.path(forResource: file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONDecoder().decode(V.self, from: data)
                callback(.success(result))
            } catch {
                callback(.failure(NSError(domain: "stub decoding error", code: -123)))
            }
        } else {
            callback(.failure(NSError(domain: "no json file", code: -321)))
        }
    }
}
