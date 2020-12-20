//
//  EGListController.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/17/20.
//

import UIKit

/**
 Convenient list component where a Header class is not required.
 
 ## Generics ##
 T: the cell type that this list will register and dequeue.
 
 U: the item type that each cell will visually represent.
 */

@available(iOS 11.0, tvOS 11.0, *)
open class EGListController<T: EGListCell<U>, U>: EGListHeaderController<T, U, UICollectionReusableView> {}
