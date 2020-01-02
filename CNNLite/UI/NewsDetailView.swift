//
//  NewsDetailView.swift
//  CNNLite
//
//  Created by Hemanth Prasad on 1/1/20.
//  Copyright © 2020 David Liman. All rights reserved.
//

import SwiftUI

struct NewsDetailContainerView: View {
    let id: String
    
    var body: some View {
        ResourceView.makeView(NewsDetail.endpoint(id: id), view: NewsDetailView.self)
    }
}

struct NewsDetailView: ContentView {
    typealias A = NewsDetail
    
    let news: NewsDetail
    
    init(content: A) {
        self.news = content
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(news.title)
                    .font(.headline)
                    .bold()
                
                Text(news.updated)
                    .font(.subheadline)
                
                Divider()
                
                Text(news.content)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(15)
   
        }
    }
}

struct NewsLinkContainerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewsDetailView(content: NewsDetail.example)
        }.navigationBarTitle(NewsDetail.example.title)
    }
}

