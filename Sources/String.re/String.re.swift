//
//  String.re.swift
//  String.re
//
//  Created by Natsuki on 2019/7/23.
//

import Foundation

extension String {
    var re: Regex? {
        return Regex(pattern: self)
    }
}

struct Regex {
    let regex: NSRegularExpression

    init?(pattern: String, options: NSRegularExpression.Options = []) {
        guard let expr = try? NSRegularExpression(pattern: pattern, options: options) else {
            return nil
        }
        regex = expr
    }

    func contains(_ haystack: String) -> Bool {
        return regex.numberOfMatches(in: haystack, range: NSRange(location: 0, length: haystack.count)) > 0
    }

    func find(_ haystack: String) -> MatchResult? {
        return regex.firstMatch(in: haystack, range: NSRange(location: 0, length: haystack.count)).map {
            MatchResult(within: haystack, from: $0)
        }
    }

    func scan(_ haystack: String) -> [MatchResult] {
        return regex.matches(in: haystack, range: NSRange(location: 0, length: haystack.count)).map {
            MatchResult(within: haystack, from: $0)
        }
    }

    func matchEntire(_ haystack: String) -> Bool {
        let range = NSRange(location: 0, length: haystack.count)
        return regex.firstMatch(in: haystack, range: range)?.range == range
    }

    func explode(_ haystack: String) -> [String] {
        let (index, array) = regex.matches(in: haystack, range: NSRange(location: 0, length: haystack.count)).reduce((haystack.startIndex, [Range<String.Index>]())) { acc, ele in
            let (from, ranges) = acc
            return (haystack.index(haystack.startIndex, offsetBy: ele.range.location + ele.range.length), ranges + [from..<haystack.index(haystack.startIndex, offsetBy: ele.range.location)])
        }
        return (array + [index..<haystack.endIndex]).map { String(haystack[$0]) }
    }

    func substitute(_ haystack: String, replacement: String) -> String {
        return substitute(haystack) { _, _ in
            replacement
        }
    }

    func substitute(_ haystack: String, replacement: @escaping (Int, MatchResult) -> String) -> String {
        let (ending, rope) = regex.matches(in: haystack, range: NSRange(location: 0, length: haystack.count)).enumerated().reduce((haystack.startIndex, "")) { acc, ele in
            let (beginning, rope) = acc
            let (idx, match) = ele
            let ending = haystack.index(haystack.startIndex, offsetBy: match.range.location + match.range.length)
            let result = MatchResult(within: haystack, from: match)
            return (ending, rope + String(haystack[beginning..<ending]) + replacement(idx, result))
        }
        return rope + String(haystack[ending..<haystack.endIndex])
    }
}


struct MatchResult {
    let text: Substring
    let captures: [Substring]

    fileprivate init(within haystack: String, from result: NSTextCheckingResult) {
        // tedious but taking care of the variant bytes String design
        let from = haystack.index(haystack.startIndex, offsetBy: result.range.location)
        let to = haystack.index(haystack.startIndex, offsetBy: result.range.location + result.range.length)
        text = haystack[from..<to]
        captures = (0..<result.numberOfRanges).map {
            result.range(at: $0)
        }.map {
            haystack[haystack.index(haystack.startIndex, offsetBy: $0.location)..<haystack.index(haystack.startIndex, offsetBy: $0.location + $0.length)]
        }
    }
}


