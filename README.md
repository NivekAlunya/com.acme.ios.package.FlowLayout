# FlowLayout

A flexible SwiftUI layout that arranges subviews in a flow, wrapping to the next line when space is exhausted. This is similar to a "tag cloud" or "flexible grid" layout.

## Features

- **Automatic Wrapping**: Subviews wrap to the next line based on their intrinsic width and available space.
- **Configurable Spacing**: Custom horizontal and vertical spacing between items.
- **Vertical Alignment**: Items within the same row are vertically centered.

## Usage

```swift
import SwiftUI
import FlowLayout

struct MyView: View {
    let tags = ["SwiftUI", "Combine", "Swift", "Layout", "iOS", "macOS", "watchOS", "tvOS"]
    
    var body: some View {
        FlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding()
    }
}
```

## Initialization

```swift
public init(horizontalSpacing: CGFloat = 8, verticalSpacing: CGFloat = 8)
```

- `horizontalSpacing`: The distance between items in a row.
- `verticalSpacing`: The distance between rows.

## Why use FlowLayout?

Standard SwiftUI containers like `HStack` and `VStack` don't support automatic wrapping. `FlowLayout` provides this missing functionality using the `Layout` protocol introduced in iOS 16.
