//
//  Internals.FetchedDiffableDataSourceSnapshotDelegate.swift
//  CoreStore
//
//  Copyright © 2018 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#if canImport(UIKit) || canImport(AppKit)

import Foundation
import CoreData

#if canImport(UIKit)

import UIKit

#elseif canImport(AppKit)

import AppKit

#endif


// MARK: - FetchedDiffableDataSourceSnapshot

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 15.0, *)
internal protocol FetchedDiffableDataSourceSnapshotHandler: AnyObject {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangContentWith snapshot: NSDiffableDataSourceSnapshotReference)
}


// MARK: - Internal

extension Internals {

    // MARK: - FetchedDiffableDataSourceSnapshotDelegate

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 15.0, *)
    internal final class FetchedDiffableDataSourceSnapshotDelegate: NSObject, NSFetchedResultsControllerDelegate {

        // MARK: Internal

        @nonobjc
        internal weak var handler: FetchedDiffableDataSourceSnapshotHandler?

        @nonobjc
        internal weak var fetchedResultsController: Internals.CoreStoreFetchedResultsController? {

            didSet {

                oldValue?.delegate = nil
                self.fetchedResultsController?.delegate = self
            }
        }

        deinit {

            self.fetchedResultsController?.delegate = nil
        }


        // MARK: NSFetchedResultsControllerDelegate

        @objc
        dynamic func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {

            self.handler?.controller(
                controller,
                didChangContentWith: snapshot
            )
        }
    }
}

#endif
