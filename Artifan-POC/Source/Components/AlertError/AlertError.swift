//
//  AlertError.swift
//  Artifan-POC
//
//  Created by Victor Castro on 29/09/24.
//

import SwiftUI

struct AlertError: View {
    let error: Error?
    
    init(_ error: Error?) {
        self.error = error
    }
    
    var body: some View {
        if let error = error {
            Text(error.localizedDescription)
                .font(.callout)
                .foregroundStyle(.red)
        }
    }
}

#Preview {
    let error = NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL no válida"])
    return AlertError(error)
}
