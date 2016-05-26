//
//  RxProductsRequestDelegateProxy.swift
//  Pods
//
//  Created by Leeroy on 26/05/2016.
//
//

import StoreKit
import RxSwift
import RxCocoa

class RxProductsRequestDelegateProxy:
	DelegateProxy,
	SKProductsRequestDelegate,
DelegateProxyType {
	
	weak private(set) var productsRequest: SKProductsRequest?
	
	private let productsResponseSubject = ReplaySubject<SKProductsResponse>.create(bufferSize: 1)
	
	var productsResponse: Observable<SKProductsResponse> {
		return productsResponseSubject
	}
	
	required init(parentObject: AnyObject) {
		self.productsRequest = (parentObject as! SKProductsRequest)
		super.init(parentObject: parentObject)
	}
	
	// MARK: - Delegate methods
	
	func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
		productsResponseSubject.onNext(response)
		self._forwardToDelegate?.productsRequest(request, didReceiveResponse: response)
	}
	
	// MARK: - Delegate proxy
	
	override class func createProxyForObject(object: AnyObject) -> AnyObject {
		let productsRequest = object as! SKProductsRequest
		return productsRequest.rx_createDelegateProxy()
	}
	
	class func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
		let productsRequest = object as! SKProductsRequest
		productsRequest.delegate = delegate.map { $0 as! SKProductsRequestDelegate }
	}
	
	class func currentDelegateFor(object: AnyObject) -> AnyObject? {
		return (object as! SKProductsRequest).delegate
	}
	
	deinit {
		productsResponseSubject.onCompleted()
	}
}
