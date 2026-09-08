//
//  ExampleView.swift
//  FlowLayout
//
//  Created by Kevin Launay on 12/01/2026.
//

import SwiftUI

enum HAlignment: String, CaseIterable, Hashable {
    case leading, center, trailing
    
    var alignment: HorizontalAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
}

enum VAlignment: String, CaseIterable, Hashable {
    case top, center, bottom
    
    var alignment: VerticalAlignment {
        switch self {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        }
    }
}

enum LDirection: String, CaseIterable, Hashable {
    case leftToRight, rightToLeft
    
    var direction: LayoutDirection {
        switch self {
        case .leftToRight: return .leftToRight
        case .rightToLeft: return .rightToLeft
        }
    }
}

public struct ExampleView: View {
    @State private var horizontalAlignment: HAlignment = .leading
    @State private var verticalAlignment: VAlignment = .center
    @State private var layoutDirection: LDirection = .leftToRight
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            Picker("Horizontal Alignment", selection: $horizontalAlignment) {
                ForEach(HAlignment.allCases, id: \.self) { alignment in
                    Text(alignment.rawValue.capitalized).tag(alignment)
                }
            }.pickerStyle(SegmentedPickerStyle())
            Picker("Vertical Alignment", selection: $verticalAlignment) {
                ForEach(VAlignment.allCases, id: \.self) { alignment in
                    Text(alignment.rawValue.capitalized).tag(alignment)
                }
            }.pickerStyle(SegmentedPickerStyle())
            Picker("Layout Direction", selection: $layoutDirection) {
                ForEach(LDirection.allCases, id: \.self) { direction in
                    Text(direction.rawValue.capitalized).tag(direction)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            FlowLayout(horizontalSpacing: 12, verticalSpacing: 12, horizontalAlignment: horizontalAlignment.alignment, verticalAlignment: verticalAlignment.alignment, layoutDirection: layoutDirection.direction) {
                ForEach(1..<101) { index in
                    let bgColor = index % 2 == 0 ? Color.blue : Color.indigo
                    Text("Item \(index)")
                        .padding(8)
                        .font(index % 5 == 0 ? .title : .body)
                        .clipShape(Capsule())
                        .background(Capsule().fill(bgColor.opacity(0.3)).stroke(bgColor))
                        .padding(8)
                }
            }
            .animation(.default, value: horizontalAlignment)
            .animation(.default, value: verticalAlignment)
            .animation(.default, value: layoutDirection)
        }
    }
}

#Preview {
    ExampleView()
}
