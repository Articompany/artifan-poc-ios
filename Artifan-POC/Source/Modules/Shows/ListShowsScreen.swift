//
//  ListShowsScreen.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/08/24.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct ListShowsScreen: View {
    @StateObject private var viewModel = ShowsViewModel()
    @State private var selectedCategory: String = "Todos"
    @State private var searchText: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    @State private var isUploading: Bool = false
    @State private var uploadStatus: String = ""
    
    let categories = ["Todos", "Dalinas", "Payasos"]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var filteredShows: [ShowModel] {
        var showsCategorized: [ShowModel] = []
        
        if selectedCategory == "Todos" {
            showsCategorized = viewModel.shows
        } else {
            showsCategorized = viewModel.shows.filter { $0.category?.name == selectedCategory }
        }
        
        if searchText.isEmpty {
            return showsCategorized
        } else {
            return showsCategorized.filter { $0.title.contains(searchText) || $0.description.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Categorías", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Text("Seleccionar imagen")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                ScrollView {
                    // AFListShowsGrid(items: filteredShows, numOfColumns: 2)
                }.refreshable {
                    await fetchShowsAvailables(refresh: true)
                }
                if isUploading {
                    ProgressView("Subiendo imagen...")
                        .padding()
                }
                
                Text(uploadStatus)
                    .foregroundColor(uploadStatus.contains("Error") ? .red : .green)
                    .padding()
            }
            .navigationTitle("Búsqueda y diversión")
            .searchable(text: $searchText, prompt: "Buscar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Perfil presionado")
                    }) {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            
        }
        .task {
            await fetchShowsAvailables()
        }
    }
    
    private func fetchShowsAvailables(refresh: Bool = false) async {
        await viewModel.fetchShows(refreshLocalData: refresh)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var onImagePicked: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // Solo imágenes
        config.selectionLimit = 1 // Limitar a una selección
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, onImagePicked: onImagePicked)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        var onImagePicked: (UIImage) -> Void
        
        init(_ parent: ImagePicker, onImagePicked: @escaping (UIImage) -> Void) {
            self.parent = parent
            self.onImagePicked = onImagePicked
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    if let uiImage = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = uiImage
                            self.onImagePicked(uiImage)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ListShowsScreen()
}
