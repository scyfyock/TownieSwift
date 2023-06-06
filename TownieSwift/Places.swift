//
//  Places.swift
//  TownieSwift
//
//  Created by Colin Fyock on 5/15/23.
//

import SwiftUI

struct Places: View {
    
    @ObservedObject var map = LocationTrackingViewControl.shared

    var body: some View {
        
        NavigationStack {
            
            VStack(
                alignment: .leading,
                spacing: 10
            ) {
                Text("\(map.getPlacesTraveled())")
            }
             
        }
        .navigationTitle("Places Traveled To")
    }
}

struct Places_Previews: PreviewProvider {
    static var previews: some View {
        Places()
        
    }
}
