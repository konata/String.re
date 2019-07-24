import XCTest
@testable import String_re

final class String_reTests: XCTestCase {
    func testInitialization() {
        let possessivePattern = #".++"#.re
        XCTAssertTrue(possessivePattern != nil)

        let invalidPossessivePattern = #".+++"#.re
        XCTAssertTrue(invalidPossessivePattern == nil)

        let negativeLookAhead = #"s(?!wift)"#.re
        XCTAssertTrue(negativeLookAhead != nil)

        let positiveLookAhead = #"s(?=wift)"#.re
        XCTAssertTrue(positiveLookAhead != nil)

        let negativeLookBehind = #"(?<!swif)t"#.re
        XCTAssertTrue(negativeLookBehind != nil)

        let positiveLookBehind = #"(?<=swif)t"#.re
        XCTAssertTrue(positiveLookBehind != nil)
    }


    func testContains() {
        [#"s(?=wift)"#.re!, #"(?<=swif)t"#.re!, #"^swift$"#.re!].forEach {
            XCTAssertTrue($0.contains("swift"))
            XCTAssertFalse($0.contains("sift"))
        }

        let sNotFollowedBySpecificCharSequence = "s(?!wift)".re!
        XCTAssertFalse(sNotFollowedBySpecificCharSequence.contains("swift"))

        let tNotPrefixWithSpecificCharSequence = "(?<!swif)t".re!
        XCTAssertFalse(tNotPrefixWithSpecificCharSequence.contains("swift"))
    }

    func testFind() {
        ["i(?=ft)".re!, "(?<=sw)i".re!, "(?<=sw)i(?=ft)".re!].forEach {
            XCTAssertEqual("i", String($0.find("swift")!.text))
        }

        let matches = "(.*)i(.*)".re!.find("swift")!
        XCTAssertEqual("swift", String(matches.text))
        XCTAssertEqual(["swift", "sw", "ft"], matches.captures.map(String.init))

        let firstWord = #"\w"#.re!
        XCTAssertEqual(firstWord.find("swift")!.text, "s")
    }


    func testScan() {
        let allWords = #"\w(\w)"#.re!
        let parts = allWords.scan("swift")
        XCTAssertEqual(parts.count, 2)
        XCTAssertEqual(parts.first!.text, "sw")
        XCTAssertEqual(parts.first!.captures.count, 2)
        XCTAssertEqual(parts.first!.captures[1], "w")

        XCTAssertEqual(parts[1].text, "if")
        XCTAssertEqual(parts[1].captures.count, 2)
        XCTAssertEqual(parts[1].captures[1], "f")
    }


    func testMatchEntire() {
        let words = """
                    swi
                    ft
                    1
                    """
        XCTAssertTrue(#"[\w\n\d]*"#.re!.matchEntire(words))
    }


    func testExplode() {
        let words = """
                    sw
                    i
                    ft
                    1b
                    2h
                    """
        XCTAssertEqual(#"[\n\d]+"#.re!.explode(words), ["sw", "i", "ft", "b", "h"])
    }

    func testSubstitute() {
        XCTAssertEqual(#"\d"#.re!.substitute("s1w34if56t", replacement: "__"), "s__w____if____t")
        XCTAssertEqual(#"\d+"#.re!.substitute("s1w34if56t", replacement: "__"), "s__w__if__t")
        XCTAssertEqual(#"\d+"#.re!.substitute("s1w34if56t") { pos, match in "\(pos)" }, "s0w1if2t")
        XCTAssertEqual(#"\d"#.re!.substitute("s1w34if56t") { pos, match in "\(pos)" }, "s0w12if34t")
    }


    static var allTests = [
        ("testInitialization", testInitialization),
        ("testContains", testContains),
        ("testFind", testFind),
        ("testScan", testScan),
        ("testMatchEntire", testMatchEntire),
        ("testExplode", testExplode)
    ]
}
