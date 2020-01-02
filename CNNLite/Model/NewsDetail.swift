//
//  News.swift
//  CNNLite
//
//  Created by Hemanth Prasad on 1/1/20.
//  Copyright © 2020 David Liman. All rights reserved.
//

import Foundation
import TinyNetworking

struct NewsDetail: Decodable, Identifiable {
    var id: String {
        return title
    }
    
    let title: String
    let updated: String
    let content: String
    
    static func endpoint(id: String) -> Endpoint<NewsDetail> {
        Endpoint<String>(.get,
                         url: URL(string: "https://lite.cnn.io")!.appendingPathComponent(id),
                         accept: .xml,
                         parse: Endpoint.parseString)
                        .compactMap(parse)
    }
}

#if DEBUG

extension NewsDetail {
    
    static var example: Self {
        return NewsDetail(
            title: "At least 5 people died in a small plane crash near Louisiana airport, officials say",
            updated: "Updated 1:28 PM ET, Sat December 28, 2019",
            content: """
(CNN) - At least five people died Saturday when a small plane crashed near Lafayette Regional Airport in Louisiana, Lafayette Fire Chief Robert Benoit said.

One person on board survived the crash, which occurred at 9:22 a.m. local time, Benoit said in a news conference. The survivor was taken to the hospital along with three people who were on the ground, Benoit said.

The eight-passenger plane was taking off from the airport when it crashed, Benoit said.

Weather conditions at Lafayette Regional Airport were listed as foggy throughout Saturday morning, with a visibility of 0.75 miles, according to the National Weather Service. At 7 a.m. local time, visibility was listed at 0.25 miles, which the NWS designates as "dense fog."

Lafayette is about 130 miles west of New Orleans.

This is a developing story. More to come.
""")
    }
}
#endif
