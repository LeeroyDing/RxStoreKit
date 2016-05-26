//
//  SKProductsRequest+Rx.swift
//  Pods
//
//  Created by Leeroy on 26/05/2016.
//
//

import StoreKit
import RxSwift
import RxCocoa

extension SKProductsRequest {
	
	func rx_createDelegateProxy() -> RxProductsRequestDelegateProxy {
		return RxProductsRequestDelegateProxy(parentObject: self)
	}
	
	var rx_delegate: DelegateProxy {
		return RxProductsRequestDelegateProxy.proxyForObject(self)
	}
	
	var rx_productsResponse: Observable<SKProductsResponse> {
		let proxy = RxProductsRequestDelegateProxy.proxyForObject(self)
		return proxy.productsResponse
	}
	
}
