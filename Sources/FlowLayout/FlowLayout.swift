// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// A custom layout that arranges subviews in a flow, wrapping to the next line when space is exhausted.
///
/// `FlowLayout` is useful for creating tag clouds, button groups, or any collection of items where the number of items
/// per row depends on their individual widths and the available container width.
public struct FlowLayout: Layout {
    /// The horizontal distance between adjacent subviews.
    public var horizontalSpacing: CGFloat
    /// The vertical distance between adjacent rows of subviews.
    public var verticalSpacing: CGFloat
    /// The horizontal alignment of items within their rows.
    public var horizontalAlignment: HorizontalAlignment
    /// The vertical alignment of items within their row's height.
    public var verticalAlignment: VerticalAlignment
    /// The layout direction (left-to-right or right-to-left).
    public var layoutDirection: LayoutDirection

    /// A cache to store pre-calculated layout information.
    public struct Cache {
        var subviewSizes: [CGSize]
    }

    /// Initializes a new FlowLayout with specified spacing and alignments.
    public init(
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8,
        horizontalAlignment: HorizontalAlignment = .leading,
        verticalAlignment: VerticalAlignment = .center,
        layoutDirection: LayoutDirection = .leftToRight
    ) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.layoutDirection = layoutDirection
    }

    public func makeCache(subviews: Subviews) -> Cache {
        Cache(subviewSizes: subviews.map { $0.sizeThatFits(.unspecified) })
    }

    public func updateCache(_ cache: inout Cache, subviews: Subviews) {
        cache.subviewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
    }

    /// Returns the size that best fits the subviews within the proposed size.
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        let result = calculateLayout(for: proposal.width ?? .infinity, cache: cache)
        return result.totalSize
    }

    /// Assigns positions to the subviews within the specified bounds.
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        let result = calculateLayout(for: bounds.width, cache: cache)
        var currentY = bounds.minY

        for line in result.lines {
            var currentX: CGFloat = 0

            // Base horizontal position calculation based on alignment and direction
            let isRTL = layoutDirection == .rightToLeft
            
            switch horizontalAlignment {
            case .leading:
                currentX = isRTL ? bounds.maxX : bounds.minX
            case .center:
                currentX = bounds.minX + (bounds.width - line.width) / 2
                if isRTL { currentX += line.width } // In RTL, we start from the right side of the centered block
            case .trailing:
                currentX = isRTL ? (bounds.minX + line.width) : (bounds.maxX - line.width)
            default:
                currentX = isRTL ? bounds.maxX : bounds.minX
            }

            for index in line.subviewIndices {
                let subview = subviews[index]
                let size = cache.subviewSizes[index]

                let yOffset: CGFloat
                switch verticalAlignment {
                case .top:
                    yOffset = 0
                case .center:
                    yOffset = (line.height - size.height) / 2
                case .bottom:
                    yOffset = line.height - size.height
                default:
                    yOffset = (line.height - size.height) / 2
                }

                if isRTL {
                    // In RTL, we place the item such that its right edge is at currentX
                    subview.place(
                        at: CGPoint(x: currentX - size.width, y: currentY + yOffset),
                        proposal: ProposedViewSize(size)
                    )
                    currentX -= size.width + horizontalSpacing
                } else {
                    subview.place(
                        at: CGPoint(x: currentX, y: currentY + yOffset),
                        proposal: ProposedViewSize(size)
                    )
                    currentX += size.width + horizontalSpacing
                }
            }

            currentY += line.height + verticalSpacing
        }
    }

    // MARK: - Helper

    private struct LayoutResult {
        struct Line {
            var subviewIndices: [Int]
            var width: CGFloat
            var height: CGFloat
        }
        var lines: [Line]
        var totalSize: CGSize
    }

    private func calculateLayout(for maxWidth: CGFloat, cache: Cache) -> LayoutResult {
        guard !cache.subviewSizes.isEmpty else {
            return LayoutResult(lines: [], totalSize: .zero)
        }

        var lines: [LayoutResult.Line] = []
        var currentLineIndices: [Int] = []
        var currentLineWidth: CGFloat = 0
        var currentLineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for (index, size) in cache.subviewSizes.enumerated() {
            if currentLineWidth + size.width > maxWidth && !currentLineIndices.isEmpty {
                lines.append(LayoutResult.Line(
                    subviewIndices: currentLineIndices,
                    width: currentLineWidth - horizontalSpacing,
                    height: currentLineHeight
                ))
                totalWidth = max(totalWidth, currentLineWidth - horizontalSpacing)
                totalHeight += currentLineHeight + verticalSpacing

                currentLineIndices = [index]
                currentLineWidth = size.width + horizontalSpacing
                currentLineHeight = size.height
            } else {
                currentLineIndices.append(index)
                currentLineWidth += size.width + horizontalSpacing
                currentLineHeight = max(currentLineHeight, size.height)
            }
        }

        if !currentLineIndices.isEmpty {
            lines.append(LayoutResult.Line(
                subviewIndices: currentLineIndices,
                width: currentLineWidth - horizontalSpacing,
                height: currentLineHeight
            ))
            totalWidth = max(totalWidth, currentLineWidth - horizontalSpacing)
            totalHeight += currentLineHeight
        }

        return LayoutResult(lines: lines, totalSize: CGSize(width: totalWidth, height: totalHeight))
    }
}
