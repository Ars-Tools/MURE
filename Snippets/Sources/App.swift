//
//  App.swift
//  MURE
//
//  Created by Kota on 2/25/R7.
//
import SwiftUI
import Artworks
import CIArtworks
@main
struct App: SwiftUI.App {
	@State var color: MTLClearColor = .init()
	@State var ciColor: CIColor = .init()
	var body: some Scene {
		WindowGroup {
			Text("Hello World")
			Canvas(artwork: testCustomFilter())
				.onAppear {
					DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
						Task { @MainActor in
							color = .init(red: .random(in: 0...1),
										  green: .random(in: 0...1),
										  blue: .random(in: 0...1),
										  alpha: 1)
							ciColor = .init(red: .random(in: 0...1),
											green: .random(in: 0...1),
											blue: 1)
						}
					}
					DispatchQueue.global().asyncAfter(deadline: .now() + 6) {
						Task { @MainActor in
							color = .init(red: .random(in: 0...1),
										  green: .random(in: 0...1),
										  blue: .random(in: 0...1),
										  alpha: 1)
							ciColor = .init(red: .random(in: 0...1),
											green: .random(in: 0...1),
											blue: 1)
						}
					}
				}
		}
	}
}
