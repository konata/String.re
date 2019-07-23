//
//  String.re.swift
//  String.re
//
//  Created by Natsuki on 2019/7/23.
//

import Foundation


extension String {
    var re: Regex {
        return Regex(pattern: self)
    }
}

struct Regex {
    let options: NSRegularExpression.Options
    let pattern: String

    init(pattern: String, options: NSRegularExpression.Options = []) {
        self.options = options
        self.pattern = pattern
    }

    func contains(_ haystack: String) -> Bool {
        fatalError()
    }

    func find(_ haystack: String) -> MatchResult? {
        fatalError()
    }

    func findAll(_ haystack: String) -> [MatchResult] {
        fatalError()
    }

    func matchEntire(_ haystack: String) -> MatchResult? {
        fatalError()
    }

    func matches(_ haystack: String) -> Bool {
        fatalError()
    }

    func explode(_ haystack: String) -> [String] {
        fatalError()
    }

    func substitute(_ haystack: String, replacement: String, limitation: Int = -1) -> String {
        return substitute(haystack, limitation: limitation) { _, _ in
            replacement
        }
    }

    func substitute(_ haystack: String, limitation: Int = -1, replacement: @escaping (Int, MatchResult) -> String) -> String {
        fatalError()
    }
}


struct MatchResult {

}


