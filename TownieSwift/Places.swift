//
//  Places.swift
//  TownieSwift
//
//  Created by Colin Fyock on 5/15/23.
//

import SwiftUI

struct Places: View {
    
    @ObservedObject var map = locator.shared
    
    var body: some View {
        
        NavigationStack {
            Spacer()
                .frame(height: 10)
            Divider()
            Spacer()
                .frame(height: 10)
            
            VStack(
                alignment: .leading,
                spacing: 10
            ) {
                ScrollView {
                    Text("\(map.getPlacesTraveled())")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                }
            }
        }
        Spacer()
        .navigationTitle("Towns Visited")
    }
}

struct Places_Previews: PreviewProvider {
    static var previews: some View {
        Places()
        
    }
}
