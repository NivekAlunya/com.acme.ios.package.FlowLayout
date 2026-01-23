//
//  Preview.swift
//  FlowLayout
//
//  Created by Kevin Launay on 12/01/2026.
//

import SwiftUI

struct Preview: View {
    var body: some View {
        FlowLayout(horizontalSpacing: 12, verticalSpacing: 12) {
            ForEach(1..<21) { index in
                Text("Item \(index)")
                    .font(index % 5 == 1 ? .title3 : .body)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(index % 2 == 0 ? Color.blue.opacity(0.15) : Color.indigo.opacity(0.15))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(index % 2 == 0 ? Color.blue : Color.indigo, lineWidth: 1))
            }
        }
        .padding()
    }
}

#Preview {
    Preview()
}
