import SwiftUI
import Request
import Foundation
import SwiftSoup

struct NewsLink: Decodable, Identifiable {
    let id: String    //=> /en/article/h_68985f0b7dd65edeb62e617d70ddbd68
    let title: String //=> Daughter-in-law of LSU coach among the 5 killed in a small plane crash ...
}

struct News: Decodable, Identifiable {
    let id: String
    let title: String
    let updated: String
    let content: String
}

var BASE_URL = "https://lite.cnn.io"

func fetchLinks() -> Request {
    return Request { Url(BASE_URL) }
}

func fetchNewsDetail(id: String) -> Request {
    return Request { Url(BASE_URL + id) }
}


// TODO: figure out way to compose optional, try? all the way from callers
func maybeParseLinks(_ data: Data?) -> [NewsLink] {
    if let _ = data {
        return parseLinks(data!)
    } else {
        return []
    }
}

func parseLinks(_ data: Data) -> [NewsLink] {
    let html: String = String.init(bytes: data, encoding: .utf8)!
    
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

func parseContent(_ acc: String, _ element: Element) throws-> String {
    let body = try! element.text()
    return acc + body + "\n\n"
}

func parseNewsDetail(id: String, data: Data) -> some View {
    let html: String = String.init(bytes: data, encoding: .utf8)!
    let doc: Document = try! SwiftSoup.parse(html)
    
    let title: String = try! doc.select("h2").text()
    let content: String = try! doc.select("#mount > div > div.afe4286c > div:nth-child(3)")
        .first()!
        .children()
        .reduce("", parseContent(_:_:))
    let updated: String = try! doc.select("#mount > div > div.afe4286c > div:nth-child(2)").text()

    return NewsDetailView(news: News(id: id, title: title, updated: updated, content: content))
}

struct NewsLinkContainerView: View {
    var placeholder: some View {
        Text("Couldn't talk to server")
    }
    
    var body: some View {
        RequestView(fetchLinks()) { data in
            self.buildNewsList(data)
            self.placeholder // spinning
        }
    }
    
    func buildNewsList(_ data: Data?) -> some View {
        NavigationView {
            List(maybeParseLinks(data)) { link in
                NavigationLink(destination: NewsDetailContainerView(link: link)) {
                    NewsLinkView(link: link)
                }
                .navigationBarTitle(Text("CNN News"), displayMode: .inline)
            }
        }
    }
}

struct NewsDetailContainerView: View {
    let link: NewsLink

    var placeholder: some View {
          Text("http-err-case")
    }

    var body: some View {
        RequestView(fetchNewsDetail(id: self.link.id)) { data in
            if data != nil {
                parseNewsDetail(id: self.link.id, data: data!)
            }
            self.placeholder
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

struct NewsDetailView: View {
    let news: News
    
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
        NewsDetailView(news: News.example)
    }
}


#if DEBUG

extension News {
    
    static var example: Self {
        return News(
            id: "some-id",
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
