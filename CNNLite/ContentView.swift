//
//  ContentView.swift
//  CNNLite
//
//  Created by dv on 12/27/19.
//  Copyright © 2019 David Liman. All rights reserved.
//

import SwiftUI
import Request
import Foundation
import SwiftSoup

struct NewsLink: Decodable, Identifiable {
    let id: String    //=> /en/article/h_68985f0b7dd65edeb62e617d70ddbd68
    let title: String //=> Daughter-in-law of LSU coach among the 5 killed in a small plane crash in Louisiana en route to bowl game
}

struct News: Decodable, Identifiable { // Hashable?
    let id: String
    let title: String
    let content: String
    let updated: String
}

struct ContentView: View {
    var placeholder: some View {
        Text("Couldn't talk to server")
    }
    
    var body: some View {
        RequestView(Request{
            Url("https://lite.cnn.io")
        }) { data in
            VStack {
                // data here is optional
                // we can apply Parser.parse func
                // output = nil-view | with-values-view
                // don't need to check != nil, call parse/1 etc
                if data != nil {
   
                    //self.buildList(data)
                    List(self.buildList(data)) { news in
                        NavigationLink(destination: self.placeholder) {
                            NewsView(news: news)
                        }
                    }
                } else {
                    self.placeholder
                }
            }
       
            self.placeholder
        }
    }
    
    // TODO: figure out way to compose optional, try? all the way from callers
    func parse(_ data: Data?) -> [NewsLink] {
        let html: String = String.init(bytes: data!, encoding: .utf8)!
        
        // TODO: figure out syntax for
        // SwiftSoup.parse.map(::select("li)).reduce(xs, { child(0).attr("href"), text() }) => [NewsLink]
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let links: Elements = try doc.select("li")
           
            return try links.array().map({ link in
                let href = try link.child(0).attr("href")
                let text = try link.text()
                return NewsLink(id: href, title: text)
            })
     

        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
            return []
            
        } catch {
            print("error")
            return []
        }
        
    }
    
    func buildList(_ data: Data?) -> some View {
        let links = self.parse(data)
        print("got links")
        return self.placeholder
    }

}

struct NewsView : View {
    let news: News
    
    var body: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading) {
                Text(news.title)
                    .font(.headline)
                    .lineLimit(1)
                Group {
                    Text(news.content)
                        .font(.caption)
                        .opacity(0.75)
                        .lineLimit(1)
                }
            }
        }
    }
}

struct NewsDetailView: View {
    var body: some View {
        Text("news-details-view")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        NewsView(news: News.example)
        ContentView()
    }
}


#if DEBUG

extension News {
    
    static var example: Self {
        return News(
            id: "h_68985f0b7dd65edeb62e617d70ddbd68", title: "At least 5 people died in a small plane crash near Louisiana airport, officials say", content: """
(CNN) - At least five people died Saturday when a small plane crashed near Lafayette Regional Airport in Louisiana, Lafayette Fire Chief Robert Benoit said.

One person on board survived the crash, which occurred at 9:22 a.m. local time, Benoit said in a news conference. The survivor was taken to the hospital along with three people who were on the ground, Benoit said.

The eight-passenger plane was taking off from the airport when it crashed, Benoit said.

Weather conditions at Lafayette Regional Airport were listed as foggy throughout Saturday morning, with a visibility of 0.75 miles, according to the National Weather Service. At 7 a.m. local time, visibility was listed at 0.25 miles, which the NWS designates as "dense fog."

Lafayette is about 130 miles west of New Orleans.

This is a developing story. More to come.
""", updated: "Updated 1:28 PM ET, Sat December 28, 2019"
        )
    }
}
#endif
