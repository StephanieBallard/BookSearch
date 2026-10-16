//
//  ContentView.swift
//  BookSearch
//
//  Created by Stephanie Ballard on 10/15/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            BookSearchViewModel().fetchBooks(title: "The wizard of oz")
        }
    }
}

#Preview {
    ContentView()
}
