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
   
                    self.parse(data: data)
                } else {
                    self.noData
                }
            }
       
            self.noData
        }
    }
    
    func parse(data: Data?) -> some View {
        let payload = String.init(bytes: data!, encoding: .utf8)
        print(payload)
        
        return self.noData
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
