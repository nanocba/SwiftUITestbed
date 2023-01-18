//
//  TestView.swift
//  SwiftUITestbed
//
//  Created by Mariano Donati on 18/01/2023.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        WithViewModel(TestViewModel.init) { viewModel in
            
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
