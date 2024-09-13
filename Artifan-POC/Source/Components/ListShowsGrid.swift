//
//  ListShowsGrid.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/09/24.
//

import SwiftUI
import Kingfisher

struct GridShowItem: Identifiable {
    let id = UUID()
    let height: CGFloat
    let title: String
    let image: String
}

struct ListShowsGrid: View {
    
    struct Column: Identifiable {
        let id = UUID()
        var gridItems = [GridShowItem]()
    }
    
    let columns: [Column]
    let spacing: CGFloat
    let horizontalPadding: CGFloat
    
    init(items: [ShowModel], numOfColumns: Int, spacing: CGFloat = 10, horizontalPadding: CGFloat = 10) {
        let gridItems: [GridShowItem] = items.map { show in
            let randomHeight = CGFloat.random(in: 200...400)
            return GridShowItem(height: randomHeight, title: show.title, image: show.banner?.url ?? "")
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
    
    private func getItemView(_ gridItem: GridShowItem) -> some View {
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
    var items: [ShowModel] = [
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil),
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil),
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil),
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil),
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil),
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil),
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil),
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil),
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil),
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil),
        ShowModel(id: 1, title: "tituel", description: "descript", city: "arequi", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/c3_8a52dfb195.webp"), category: nil, photos: [], whatsapp: nil, socialMedia: nil)
    ]
    return ListShowsGrid(items: items, numOfColumns: 2, spacing: 10, horizontalPadding: 15)
    
}
