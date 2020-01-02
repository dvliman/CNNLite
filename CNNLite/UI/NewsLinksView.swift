//
//  ListPage.swift
//  CNNLite
//
//  Created by Hemanth Prasad on 12/30/19.
//  Copyright © 2019 David Liman. All rights reserved.
//

import SwiftUI
import TinyNetworking
import Combine

struct ListPage: View {
    var body: some View {
        ResourceView.makeView(NewsLink.endpoint, view: NewsLinksView.self)
    }
}

struct NewsLinksView: ContentView {
    typealias A = [NewsLink]
    
    let newsLinks: [NewsLink]
    
    init(content newsLinks: [NewsLink]) {
        self.newsLinks = newsLinks
    }
    
    var body: some View {
        NavigationView {
            List(newsLinks) { link in
                NavigationLink(destination: NewsDetailContainerView(id: link.id)) {
                    NewsLinkView(link: link)
                }.navigationBarTitle(Text("CNN News"), displayMode: .inline)
            }
        }
    }
}

struct NewsLinkView : View {
    let link: NewsLink
    
    var body: some View {
        Text(link.title)
            .font(.headline)
            .bold()
            .lineLimit(2)
    }
}

#if DEBUG

struct ListPage_Previews: PreviewProvider {
    static var previews: some View {
        NewsLinksView(content: NewsLink.examples)
    }
}

extension NewsLink {
    static var examples: [Self] {
        [NewsLink(id: "1", title: "At least 5 people died in a small plane crash near Louisiana airport, officials say"),
        NewsLink(id: "1", title: "At least 5 people died in a small plane crash near Louisiana airport, officials say"),
        NewsLink(id: "1", title: "At least 5 people died in a small plane crash near Louisiana airport, officials say"),
        NewsLink(id: "1", title: "At least 5 people died in a small plane crash near Louisiana airport, officials say"),
        NewsLink(id: "1", title: "At least 5 people died in a small plane crash near Louisiana airport, officials say"),
        NewsLink(id: "1", title: "At least 5 people died in a small plane crash near Louisiana airport, officials say")]
    }
}

#endif
