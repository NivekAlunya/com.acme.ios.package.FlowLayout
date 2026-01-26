import Testing
import SwiftUI
@testable import FlowLayout

@Suite("FlowLayout Tests")
struct FlowLayoutTests {
    
    @Test("Default initialization")
    func testDefaultInitialization() {
        let layout = FlowLayout()
        #expect(layout.horizontalSpacing == 8)
        #expect(layout.verticalSpacing == 8)
        #expect(layout.horizontalAlignment == .leading)
        #expect(layout.verticalAlignment == .center)
    }
    
    @Test("Custom initialization")
    func testCustomInitialization() {
        let layout = FlowLayout(horizontalSpacing: 10, verticalSpacing: 15, horizontalAlignment: .center, verticalAlignment: .top, layoutDirection: .rightToLeft)
        #expect(layout.horizontalSpacing == 10)
        #expect(layout.verticalSpacing == 15)
        #expect(layout.horizontalAlignment == .center)
        #expect(layout.verticalAlignment == .top)
        #expect(layout.layoutDirection == .rightToLeft)
    }
}
