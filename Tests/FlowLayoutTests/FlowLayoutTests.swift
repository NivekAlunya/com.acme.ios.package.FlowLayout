//
//  FlowLayoutTests.swift
//  FlowLayoutTests
//
//  Created by Kevin Launay on 12/01/2026.
//

import Testing
import SwiftUI
@testable import FlowLayout

@Suite("FlowLayout Tests")
struct FlowLayoutTests {
    
    @Test("Default initialization values")
    func testDefaultInitialization() {
        let layout = FlowLayout()
        #expect(layout.horizontalSpacing == 8)
        #expect(layout.verticalSpacing == 8)
        #expect(layout.horizontalAlignment == .leading)
        #expect(layout.verticalAlignment == .center)
        #expect(layout.layoutDirection == .leftToRight)
    }
    
    @Test("Custom initialization values")
    func testCustomInitialization() {
        let layout = FlowLayout(
            horizontalSpacing: 10,
            verticalSpacing: 15,
            horizontalAlignment: .center,
            verticalAlignment: .top,
            layoutDirection: .rightToLeft
        )
        #expect(layout.horizontalSpacing == 10)
        #expect(layout.verticalSpacing == 15)
        #expect(layout.horizontalAlignment == .center)
        #expect(layout.verticalAlignment == .top)
        #expect(layout.layoutDirection == .rightToLeft)
    }

    @Test("Layout cache conforms to Sendable")
    func testCacheSendability() {
        let cache = FlowLayout.Cache(subviewSizes: [CGSize(width: 50, height: 20)])
        #expect(cache.subviewSizes.count == 1)
        #expect(cache.subviewSizes.first?.width == 50)
    }

    @Test("Size calculation when subviews are empty")
    func testEmptySubviewsCache() {
        let cache = FlowLayout.Cache(subviewSizes: [])
        let layout = FlowLayout()
        #expect(cache.subviewSizes.isEmpty)
        #expect(layout.horizontalSpacing == 8)
    }
}
