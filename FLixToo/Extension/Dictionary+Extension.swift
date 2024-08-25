//
//  Dictionary+Extensino.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import Foundation

extension Dictionary {
    func toJSONString() -> String {
        do {
            return String(data: try JSONSerialization.data(withJSONObject: self), encoding: .utf8) ?? ""
        } catch {
            print(error)
            return ""
        }
    }
}
