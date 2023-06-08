//
//  UIAlertController.swift
//  TownieSwift
//
//  Created by Colin Fyock on 6/8/23.
//

import Foundation
import SwiftUI

struct UIAlert: View {
    @State private var didFail = true
    let alertTitle: String = "No Location Found"

    var body: some View {
        Text("Blue")
            .alert(
                alertTitle,
                isPresented: $didFail
            ) {
                Button("OK") {
                    // Handle the acknowledgement.
                }
            } message: {
                Text("Please check your credentials and try again.")
            }
    }
}


struct Test: PreviewProvider {
    static var previews: some View {
        UIAlert()
    }
}
