//
// Demo
// Copyright © 2020 John Rommel Estropia, Inc. All rights reserved.

import CoreStore
import UIKit


// MARK: - Modern.ColorsDemo.UIKit

extension Modern.ColorsDemo.UIKit {
    
    // MARK: - Modern.ColorsDemo.UIKit.ListViewController
    
    final class ListViewController: UITableViewController {
        
        /**
         ⭐️ Sample 1: Setting up a `DiffableDataSource.TableViewAdapter` that will manage tableView snapshot updates automatically. We can use the built-in `DiffableDataSource.TableViewAdapter` type directly, but in our case we want to enabled `UITableView` cell deletions so we create a custom subclass `DeletionEnabledDataSource` (see declaration below).
         */
        private lazy var dataSource: DiffableDataSource.TableViewAdapter<Modern.ColorsDemo.Palette> = DeletionEnabledDataSource(
            tableView: self.tableView,
            dataStack: Modern.ColorsDemo.dataStack,
            cellProvider: { (tableView, indexPath, palette) in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: Modern.ColorsDemo.UIKit.ItemCell.reuseIdentifier,
                    for: indexPath
                ) as! Modern.ColorsDemo.UIKit.ItemCell
                cell.setPalette(palette)
                return cell
            }
        )
        
        /**
         ⭐️ Sample 2: Once the views are created, we can start binding `ListPublisher` updates to the `DiffableDataSource`. We typically call this at the end of `viewDidLoad`. Note that the `addObserver`'s closure argument will only be called on the succeeding updates, so to immediately display the current values, we need to call `dataSource.apply()` once.
         */
        private func startObservingList() {
            
            self.listPublisher.addObserver(self) { (listPublisher) in
                
                self.dataSource.apply(
                    listPublisher.snapshot,
                    animatingDifferences: true
                )
            }
            self.dataSource.apply(
                listPublisher.snapshot,
                animatingDifferences: false
            )
        }
        
        /**
         ⭐️ Sample 3: We can end monitoring updates anytime. `removeObserver()` was called here for illustration purposes only. `ListPublisher`s safely remove deallocated observers automatically.
         */
        deinit {
            
            self.listPublisher.removeObserver(self)
        }

        /**
         ⭐️ Sample 4: This is the custom `DiffableDataSource.TableViewAdapter` subclass we wrote that enabled swipe-to-delete gestures on the `UITableView`.
         */
        final class DeletionEnabledDataSource: DiffableDataSource.TableViewAdapter<Modern.ColorsDemo.Palette> {

            override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

                switch editingStyle {

                case .delete:
                    guard let itemID = self.itemID(for: indexPath) else {
                        
                        return
                    }
                    self.dataStack.perform(
                        asynchronous: { (transaction) in

                            transaction.delete(objectIDs: [itemID])
                        },
                        completion: { _ in }
                    )

                default:
                    break
                }
            }
        }
        
        
        // MARK: Internal
        
        init(
            listPublisher: ListPublisher<Modern.ColorsDemo.Palette>,
            onPaletteTapped: @escaping (ObjectPublisher<Modern.ColorsDemo.Palette>) -> Void
        ) {
            
            self.listPublisher = listPublisher
            self.onPaletteTapped = onPaletteTapped
            
            super.init(style: .plain)
        }

        
        // MARK: UIViewController

        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            self.tableView.register(
                Modern.ColorsDemo.UIKit.ItemCell.self,
                forCellReuseIdentifier: Modern.ColorsDemo.UIKit.ItemCell.reuseIdentifier
            )

            self.startObservingList()
        }
        
        
        // MARK: UITableViewDelegate
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            self.onPaletteTapped(
                self.listPublisher.snapshot[indexPath]
            )
        }
        
        
        // MARK: Private
        
        private let listPublisher: ListPublisher<Modern.ColorsDemo.Palette>
        private let onPaletteTapped: (ObjectPublisher<Modern.ColorsDemo.Palette>) -> Void
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            
            fatalError()
        }
    }
}
