//
//  ShowView.swift
//  Artifan-POC
//
//  Created by Victor Castro on 16/08/24.
//

import SwiftUI

struct ShowView: View {
    let show: ShowModel
    
    var body: some View {
        Text(show.title)
    }
}

#Preview {
    ShowView(show: ShowModel(id: 1, title: "Titulo", description: "", city: "Arequipa", banner: nil, category: nil))
}
