//
//  TestTemplateView.swift
//  SwiftUITestbed
//
//  Created by Mariano Donati on 03/03/2023.
//

import SwiftUI

struct TestTemplateView: View {
    var body: some View {
        WithViewModel(TestTemplateViewModel()) { viewModel in
            // Describe the layout here
        }
    }
}

struct TestTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        TestTemplateView()
    }
}
