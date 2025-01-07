//
//  ContentView.swift
//  searchImages
//
//  Created by ritessshhh on 1/6/25.
//

import SwiftUI

struct SuperTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = { _ in }
    var commit: () -> () = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .foregroundColor(.white)
            }
            TextField(
                "",
                text: $text,
                onEditingChanged: editingChanged,
                onCommit: commit
            )
            .foregroundColor(.white)
        }
    }
}

struct ContentView: View {
    @StateObject private var photoFetcher = PhotoFetcher()
    
    @State private var searchText: String = ""
    @State private var selectedItem: Int? = nil
    @State private var position = CGSize.zero
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            // Check if user has granted permission
            let permission: Bool = photoFetcher.authorizationStatus == .authorized || photoFetcher.authorizationStatus == .limited
            if permission {
                // Authorized: show the main layout with photos
                VStack {
                    ZStack(alignment: .topLeading) {
                        // Show real photos from the library
                        PhotosGrid
                        
                        // Title
                        Title
                        
                        // Search bar with refresh button
                        SearchBar
                    }
                }
                
                // Show the selected item full-screen if any
                if let selectedItem {
                    FullScreenImage(selectedItem: selectedItem)
                }
            } else {
                // Not authorized: show a button to request permission
                VStack {
                    Text("We need permission to show your photos")
                        .font(.title3)
                        .padding(.bottom, 16)
                    
                    Button("Request Permission") {
                        photoFetcher.requestPermission()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
        }
    }
    
    // MARK: - Subviews
    
    /// The photo grid, replacing the random-color rectangles.
    var PhotosGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 100), spacing: 1),
                GridItem(.flexible(minimum: 100), spacing: 1),
                GridItem(.flexible(minimum: 100), spacing: 1),
                GridItem(.flexible(minimum: 100), spacing: 1)
            ], spacing: 1) {
                ForEach(photoFetcher.images.indices, id: \.self) { index in
                    let image = photoFetcher.images[index]

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill() // Ensures the image fills the square
                        .frame(width: 100, height: 100) // Square box
                        .clipped() // Crops any overflow
                        .matchedGeometryEffect(id: index, in: namespace)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                selectedItem = index
                            }
                        }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    /// The title text.
    var Title: some View {
        Text("Phot")
            .bold()
            .font(.largeTitle)
            .padding(.top, 50)
            .padding(.leading, 20)
            .foregroundStyle(Color.white)
            .ignoresSafeArea(.all)
    }
    
    /// The custom search bar with a refresh button.
    var SearchBar: some View {
        GeometryReader { geometry in
            // We'll stack a refresh button and the existing search bar horizontally
            HStack {
                // 2. Existing search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    
                    SuperTextField(
                        placeholder: Text("Search").foregroundColor(.white),
                        text: $searchText
                    )
                    .padding(.vertical, 10)
                    .padding(.horizontal, 5)
                    .accentColor(.white)
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.blue)
                )
                // Adjust width as needed so it fits next to the refresh button
                .frame(width: 260, height: 50)
                
                Button(action: {
                    // Re-fetch the photos when tapped
                    photoFetcher.fetchPhotos()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                }
                .background(
                    Circle()
                        .fill(Color.blue)
                )
                .frame(width: 50, height: 50)

            }
            
            // Position the entire HStack
            .frame(width: geometry.size.width, height: 50)
            .position(x: geometry.size.width / 2, y: geometry.size.height - 40)
        }
    }
    
    /// The full-screen view when a photo is selected.
    func FullScreenImage(selectedItem: Int) -> some View {
        // Guard in case the index is out of range
        guard selectedItem < photoFetcher.images.count else { return AnyView(EmptyView()) }
        
        return AnyView(
            ZStack {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                Image(uiImage: photoFetcher.images[selectedItem])
                    .resizable()
                    .scaledToFit()
                    .matchedGeometryEffect(id: selectedItem, in: namespace)
                    .zIndex(2)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            self.selectedItem = nil
                            self.position = .zero
                        }
                    }
                    .offset(position)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.position = value.translation
                            }
                            .onEnded { value in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                    if abs(self.position.height) > 200 {
                                        self.selectedItem = nil
                                        self.position = .zero
                                    }
                                    else {
                                        self.position = .zero
                                    }
                                }
                            }
                        )
            }
        )
    }
}

#Preview {
    ContentView()
}
