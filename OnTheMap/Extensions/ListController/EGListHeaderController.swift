//
//  ListHeaderController.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/17/20.
//

import UIKit

/**
 ListHeaderController helps register, dequeues, and sets up cells with their respective items to render in a standard single section list.

 ## Generics ##
 T: the cell type that this list will register and dequeue.
 
 U: the item type that each cell will visually represent.
 
 H: the header type above the section of cells.
 
 */
@available(iOS 11.0, tvOS 11.0, *)
open class EGListHeaderController<T: EGListCell<U>, U, H: UICollectionReusableView>: EGListHeaderFooterController<T, U, H, UICollectionReusableView> {}
