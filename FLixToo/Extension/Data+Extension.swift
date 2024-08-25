//
//  Data+Extension.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import Foundation

extension Data {
    func convertToDictionary() -> [String: Any] {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
            return json ?? [:]
        } catch {
            print(error)
        }
        return [:]
    }
}
