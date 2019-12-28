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

struct ContentView: View {
    var noData: some View {
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
   
                    self.buildList(data)
                } else {
                    self.noData
                }
            }
       
            self.noData
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
        return self.noData
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
