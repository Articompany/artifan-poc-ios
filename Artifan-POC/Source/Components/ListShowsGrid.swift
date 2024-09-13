//
//  ListShowsGrid.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/09/24.
//

import SwiftUI

struct GridShowItem: Identifiable {
    let id = UUID()
    let height: CGFloat
    let title: String
}

struct ListShowsGrid: View {
    
    struct Column: Identifiable {
        let id = UUID()
        var gridItems = [GridShowItem]()
    }
    
    let columns: [Column]
    let spacing: CGFloat
    let horizontalPadding: CGFloat
    
    init(gridItems: [GridShowItem], numOfColumns: Int, spacing: CGFloat = 10, horizontalPadding: CGFloat = 10) {
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        var columns = [Column]()
        for _ in 0 ..< numOfColumns {
            columns.append(Column())
        }
        
        var columnsHeight = Array<CGFloat>(repeating: 0, count: numOfColumns)
        
        for gridItem in gridItems {
            var smallestColumnIndex = 0
            var smallesHeight = columnsHeight.first!
            for i in 1 ..< columnsHeight.count {
                let curHeight = columnsHeight[i]
                if curHeight < smallesHeight {
                    smallesHeight = curHeight
                    smallestColumnIndex = i
                }
            }
            
            columns[smallestColumnIndex].gridItems.append(gridItem)
            columnsHeight[smallestColumnIndex] += gridItem.height
        }
        
        self.columns = columns
    }
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top, spacing: spacing) {
                ForEach(columns) { column in
                    LazyVStack(spacing: spacing) {
                        ForEach(column.gridItems) { gridItem in
                            Rectangle()
                                .foregroundColor(.blue)
                                .frame(height: gridItem.height)
                                .overlay(
                                    Text(gridItem.title)
                                        .font(.system(size: 30, weight: .bold))
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
    }
}

#Preview {
    var gridItems = [GridShowItem]()
    for i in 0 ..< 30 {
        let randomHeight = CGFloat.random(in: 100...400)
        gridItems.append(GridShowItem(height: randomHeight, title: String(i)))
    }
    return ListShowsGrid(gridItems: gridItems, numOfColumns: 2, spacing: 10, horizontalPadding: 15)
    
}
