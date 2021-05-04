//
//  TagsList.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 28/04/21.
//

import SwiftUI

struct TagsList: View {
    
    @Binding var selectedTags: Set<Tag>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Tag.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Tag.name, ascending: false)
        ]
    ) var allTags: FetchedResults<Tag>
    
    private var orderedTags: [Tag] { Array(allTags).sorted() }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ForEach(0 ..< self.rowCounts(geometry).count, id: \.self) { rowIndex in
                    HStack {
                        ForEach(0 ..< self.rowCounts(geometry)[rowIndex], id: \.self) { itemIndex in
                            TagButton(tag: self.tag(rowCounts: self.rowCounts(geometry), rowIndex: rowIndex, itemIndex: itemIndex), selectedTags: self.$selectedTags)
                        }
                        Spacer()
                    }.padding(.vertical, 4)
                }
                Spacer()
            }
        }
    }
    
    // MARK: - Methods
    private func rowCounts(_ geometry: GeometryProxy) -> [Int] {
        TagsList.rowCounts(tags: orderedTags, padding: 26, parentWidth: geometry.size.width)
    }
    
    private func tag(rowCounts: [Int], rowIndex: Int, itemIndex: Int) -> Tag {
        let sumOfPreviousRows = rowCounts.enumerated().reduce(0) { total, next in
            if next.offset < rowIndex {
                return total + next.element
            } else {
                return total
            }
        }
        let orderedTagsIndex = sumOfPreviousRows + itemIndex
        guard orderedTags.count > orderedTagsIndex else { return Tag() }
        return orderedTags[orderedTagsIndex]
    }
}

private struct TagButton: View {
    
    // MARK: - Properties
    let tag: Tag
    @Binding var selectedTags: Set<Tag>
    
    private let vPad: CGFloat = 13
    private let hPad: CGFloat = 22
    private let radius: CGFloat = 24
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            if self.selectedTags.contains(tag) {
                self.selectedTags.remove(tag)
            } else {
                self.selectedTags.insert(tag)
            }
        }) {
            if self.selectedTags.contains(tag) {
                HStack {
                    Text(tag.name)
                        .font(.headline)
                }
                .padding(.vertical, vPad)
                .padding(.horizontal, hPad)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(radius)
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(Color(UIColor.systemBackground), lineWidth: 1)
                )
                
            } else {
                HStack {
                    Text(tag.name)
                        .font(.headline)
                        .fontWeight(.light)
                }
                .padding(.vertical, vPad)
                .padding(.horizontal, hPad)
                .foregroundColor(.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
    }
}

private extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

private extension TagsList {
    
    static func rowCounts(tags: [Tag], padding: CGFloat, parentWidth: CGFloat) -> [Int] {
        let tagWidths = tags.map{$0.name.widthOfString(usingFont: UIFont.preferredFont(forTextStyle: .headline))}
        
        var currentLineTotal: CGFloat = 0
        var currentRowCount: Int = 0
        var result: [Int] = []
        
        for tagWidth in tagWidths {
            let effectiveWidth = tagWidth + (2 * padding)
            if currentLineTotal + effectiveWidth <= parentWidth {
                currentLineTotal += effectiveWidth
                currentRowCount += 1
                guard result.count != 0 else { result.append(1); continue }
                result[result.count - 1] = currentRowCount
            } else {
                currentLineTotal = effectiveWidth
                currentRowCount = 1
                result.append(1)
            }
        }
        
        return result
    }
}
