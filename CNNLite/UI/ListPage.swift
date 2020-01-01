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
    @ObservedObject var links = Resource(endpoint: NewsLink.endpoint)
    
    var body: some View {
        Group {
            if links.value == nil {
                ListPagePlaceHolder()
            } else {
                NavigationView {
                    List(links.value!) { link in
                        NavigationLink(destination: NewsDetailContainerView(link: link)) {
                            NewsLinkView(link: link)
                        }.navigationBarTitle("CNN News")
                    }
                }
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

struct ListPagePlaceHolder: View {
    var body: some View {
        Text("Connecting to Server")
    }
}

#if DEBUG

struct ListPage_Previews: PreviewProvider {
    static var previews: some View {
        ListPage(links: Resource(endpoint: NewsLink.endpoint, value: NewsLink.examples))
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
