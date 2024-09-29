//
//  ListShowsGrid.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/09/24.
//

import SwiftUI
import Kingfisher

struct AFGridItem: Identifiable {
    let id = UUID()
    let height: CGFloat
    let title: String
    let image: String
}

protocol GridItemProtocol {
    var title: String { get }
    var image: String { get }
}

struct AFGridItems: View {
    
    struct Column: Identifiable {
        let id = UUID()
        var gridItems = [AFGridItem]()
    }
    
    let columns: [Column]
    let spacing: CGFloat
    let horizontalPadding: CGFloat
    
    init(items: [GridItemProtocol], numOfColumns: Int, spacing: CGFloat = 10, horizontalPadding: CGFloat = 10) {
        let gridItems: [AFGridItem] = items.map { item in
            let randomHeight = CGFloat.random(in: 200...400)
            return AFGridItem(height: randomHeight, title: item.title, image: item.image)
        }
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
                            getItemView(gridItem)
                        }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
    }
    
    private func getItemView(_ gridItem: AFGridItem) -> some View {
        ZStack {
            GeometryReader { reader in
                KFImage(URL(string: gridItem.image))
                    .resizable()
                    .scaledToFill()
                    .frame(width: reader.size.width, height: reader.size.height, alignment: .center)
            }
        }
        .frame(height: gridItem.height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    struct ArtistPreview: GridItemProtocol {
        var title: String
        var image: String
    }
    
    let gridItemsPreview: [ArtistPreview] = [
        ArtistPreview(title: "Title 1", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/medium_b1_cdc2ad7b5e.png"),
        ArtistPreview(title: "Title 2", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/large_r0_f4937416e7.jpg"),
        ArtistPreview(title: "Title 3", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/e1_caf847d69e.png"),
        ArtistPreview(title: "Title 4", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/medium_b1_cdc2ad7b5e.png"),
        ArtistPreview(title: "Title 5", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/small_t0_088d280350.jpg"),
        ArtistPreview(title: "Title 5", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/small_k0_c1f85d1c5f.jpg"),
        ArtistPreview(title: "Title 5", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/small_c0_e79bf07396.jpg"),
        ArtistPreview(title: "Title 5", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/small_d1_271c05bb0b.jpg")
    ]

    return AFGridItems(items: gridItemsPreview, numOfColumns: 2, spacing: 10, horizontalPadding: 15)
    
}
