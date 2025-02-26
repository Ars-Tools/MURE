//
//  Canvas.swift
//  MURE
//
//  Created by Kota on 2/25/R7.
//
@preconcurrency import SwiftUI
@preconcurrency import os.log
public struct Canvas {
	let artwork: Artwork
	public init(artwork item: Artwork) {
		artwork = item
	}
}
#if canImport(UIKit)
extension Canvas: UIViewControllerRepresentable {
	final class View: UIView {
		override class var layerClass: AnyClass {
			CAMetalLayer.self
		}
	}
	public final class UIViewControllerType: UIViewController, @preconcurrency CAMetalDisplayLinkDelegate {
		var displayLink: CAMetalDisplayLink?
		var delegate: ((CAMetalDisplayLink.Update) -> Void)?
		public override func viewDidAppear(_ animated: Bool) {
			super.viewDidAppear(animated)
			displayLink?.add(to: .main, forMode: .default)
		}
		public override func viewWillDisappear(_ animated: Bool) {
			displayLink?.remove(from: .main, forMode: .default)
			super.viewWillDisappear(animated)
		}
		public func metalDisplayLink(_ link: CAMetalDisplayLink, needsUpdate update: CAMetalDisplayLink.Update) {
			autoreleasepool {
				delegate?(update)
			}
		}
	}
	public func makeUIViewController(context: Context) -> UIViewControllerType {
		let uiViewController = UIViewControllerType()
		uiViewController.view = View()
		switch uiViewController.view.layer {
		case let metalLayer as CAMetalLayer:
			metalLayer.device = context.environment.mtlDevice
			metalLayer.framebufferOnly = false
			uiViewController.displayLink = .init(metalLayer: metalLayer)
			uiViewController.displayLink?.delegate = uiViewController
		default:
			break
		}
		return uiViewController
	}
	public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
		do {
			guard
				let metalLayer = uiViewController.view.layer as?CAMetalLayer,
				let mtlCommandQueue = context.environment.mtlCommandQueue, mtlCommandQueue.device === metalLayer.device else {
				enum Error: Swift.Error {
					case noValidContext
				}
				throw Error.noValidContext
			}
			let procedure = try artwork(colorspace: metalLayer.colorspace,
										pixelFormat: metalLayer.pixelFormat,
										mtlCommandQueue: mtlCommandQueue)
			uiViewController.delegate = {
				guard let mtlCommandBuffer = mtlCommandQueue.makeCommandBuffer() else { return }
				procedure($0.targetTimestamp, $0.drawable.texture, mtlCommandBuffer)
				mtlCommandBuffer.present($0.drawable)
				mtlCommandBuffer.commit()
			}
		} catch {
			os_log(.error, log: .default, "%{public}@", error.localizedDescription)
		}
	}
	public func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: UIViewControllerType, context: Context) -> CGSize? {
		guard
			let width = proposal.width, width.isNormal,
			let height = proposal.height, height.isNormal,
			let layer = uiViewController.view.layer as?CAMetalLayer else {
			return.none
		}
		layer.drawableSize = .init(width: width, height: height)
		return.some(layer.drawableSize)
	}
}
#else
extension Canvas: NSViewControllerRepresentable {
	public final class NSViewControllerType: NSViewController, @preconcurrency CAMetalDisplayLinkDelegate {
		var displayLink: CAMetalDisplayLink?
		var delegate: ((CAMetalDisplayLink.Update) -> Void)?
		public override func viewDidAppear() {
			super.viewDidAppear()
			displayLink?.add(to: .main, forMode: .default)
		}
		public override func viewWillDisappear() {
			displayLink?.remove(from: .main, forMode: .default)
			super.viewWillDisappear()
		}
		public func metalDisplayLink(_ link: CAMetalDisplayLink, needsUpdate update: CAMetalDisplayLink.Update) {
			autoreleasepool {
				delegate?(update)
			}
		}
	}
	public func makeNSViewController(context: Context) -> NSViewControllerType {
		let metalLayer = CAMetalLayer()
		let nsViewController = NSViewControllerType()
		metalLayer.device = context.environment.mtlDevice
		metalLayer.framebufferOnly = false
		nsViewController.view.layer = metalLayer
		nsViewController.view.wantsLayer = true
		nsViewController.displayLink = .init(metalLayer: metalLayer)
		nsViewController.displayLink?.delegate = nsViewController
		return nsViewController
	}
	public func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
		do {
			guard
				let metalLayer = nsViewController.view.layer as?CAMetalLayer,
				let mtlCommandQueue = context.environment.mtlCommandQueue, mtlCommandQueue.device === metalLayer.device else {
				enum Error: Swift.Error {
					case noValidContext
				}
				throw Error.noValidContext
			}
			let procedure = try artwork(colorspace: metalLayer.colorspace,
										pixelFormat: metalLayer.pixelFormat,
										mtlCommandQueue: mtlCommandQueue)
			nsViewController.delegate = {
				guard let mtlCommandBuffer = mtlCommandQueue.makeCommandBuffer() else { return }
				procedure($0.targetTimestamp, $0.drawable.texture, mtlCommandBuffer)
				mtlCommandBuffer.present($0.drawable)
				mtlCommandBuffer.commit()
			}
		} catch {
			os_log(.error, log: .default, "%{public}@", error.localizedDescription)
		}
	}
	public func sizeThatFits(_ proposal: ProposedViewSize, nsViewController: NSViewControllerType, context: Context) -> CGSize? {
		guard
			let width = proposal.width, width.isNormal,
			let height = proposal.height, height.isNormal,
			let layer = nsViewController.view.layer as?CAMetalLayer else {
			return.none
		}
		layer.drawableSize = .init(width: width, height: height)
		return.some(layer.drawableSize)
	}
}
#endif
