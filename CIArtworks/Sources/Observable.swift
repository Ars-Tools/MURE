//
//  Observable.swift
//  MURE
//
//  Created by Kota on 2/25/R7.
//
@preconcurrency import CoreImage
@preconcurrency import Observation
@dynamicMemberLookup
public final class ObservableCIFilter<Processor: CIFilter & Observable> {
	let filter: Processor
	let observer: ObservationRegistrar
	init(filter: Processor) {
		observer = .init()
		self.filter = filter
	}
	public subscript<R>(dynamicMember keyPath: KeyPath<Processor, R>) -> R {
		_read {
			observer.access(filter, keyPath: \.self)
			yield filter[keyPath: keyPath]
		}
		_modify {
			observer.access(filter, keyPath: \.self)
			observer.willSet(filter, keyPath: \.self)
			defer {
				observer.didSet(filter, keyPath: \.self)
			}
			var filter = filter[keyPath: keyPath]
			yield &filter
		}
	}
}
