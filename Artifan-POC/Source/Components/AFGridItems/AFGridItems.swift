//
//  ListShowsGrid.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/09/24.
//

import SwiftUI
import Kingfisher

protocol AFGridItemProtocol {
    var gridID: String { get }
    var gridTitle: String { get }
    var gridImage: String { get }
    var gridDescription: String { get }
}

struct AFGridItem: Identifiable {
    let id: String
    let title: String
    let image: String
    let description: String
    let height: CGFloat
}

struct AFGridItems: View {
    
    struct Column: Identifiable {
        let id = UUID()
        var gridItems = [AFGridItem]()
    }
    
    let columns: [Column]
    let spacing: CGFloat
    let horizontalPadding: CGFloat
    let onTapItem: ((AFGridItem) -> Void)?
    
    init(items: [AFGridItemProtocol], numOfColumns: Int, spacing: CGFloat = 10, horizontalPadding: CGFloat = 10, onTapItem: ((AFGridItem) -> Void)? = nil) {
        let gridItems: [AFGridItem] = items.map { item in
            let randomHeight = CGFloat.random(in: 200...400)
            return AFGridItem(id: item.gridID, title: item.gridTitle, image: item.gridImage, description: item.gridDescription, height: randomHeight)
        }
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        self.onTapItem = onTapItem
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
                            NavigationLink(destination: ArtistDetailScreen(gridItem: gridItem)) {
                                getItemView(gridItem)
                            }
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
    struct ArtistPreview: AFGridItemProtocol {
        var gridID: String
        var gridTitle: String
        var gridImage: String
        var gridDescription: String
    }
    
    let gridItemsPreview: [ArtistPreview] = [
        ArtistPreview(gridID: "1", gridTitle: "Title 1", gridImage: "https://artifan-dev.s3.sa-east-1.amazonaws.com/medium_b1_cdc2ad7b5e.png", gridDescription: "Description 1"),
        ArtistPreview(gridID: "2", gridTitle: "Title 2", gridImage: "https://artifan-dev.s3.sa-east-1.amazonaws.com/large_r0_f4937416e7.jpg", gridDescription: "Description 2"),
        ArtistPreview(gridID: "3", gridTitle: "Title 3", gridImage: "https://artifan-dev.s3.sa-east-1.amazonaws.com/e1_caf847d69e.png", gridDescription: "Description 3"),
        ArtistPreview(gridID: "4", gridTitle: "Title 4", gridImage: "https://artifan-dev.s3.sa-east-1.amazonaws.com/medium_b1_cdc2ad7b5e.png", gridDescription: "Description 4"),
        ArtistPreview(gridID: "5", gridTitle: "Title 5", gridImage: "https://artifan-dev.s3.sa-east-1.amazonaws.com/small_t0_088d280350.jpg", gridDescription: "Description 5"),
        ArtistPreview(gridID: "6", gridTitle: "Title 6", gridImage: "https://artifan-dev.s3.sa-east-1.amazonaws.com/small_k0_c1f85d1c5f.jpg", gridDescription: "Description 6"),
        ArtistPreview(gridID: "7", gridTitle: "Title 7", gridImage: "https://artifan-dev.s3.sa-east-1.amazonaws.com/small_c0_e79bf07396.jpg", gridDescription: "Description 7"),
        ArtistPreview(gridID: "8", gridTitle: "Title 8", gridImage: "https://artifan-dev.s3.sa-east-1.amazonaws.com/small_d1_271c05bb0b.jpg", gridDescription: "Description 8")
    ]
    
    return AFGridItems(items: gridItemsPreview, numOfColumns: 2, spacing: 10, horizontalPadding: 15)
}
