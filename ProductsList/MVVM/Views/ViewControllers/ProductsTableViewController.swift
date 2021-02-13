//
//  ViewController.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import SafariServices
import UIKit

// Products Table View list with subclass of BaseViewController
class ProductsTableViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    fileprivate let viewModel = ProductsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Products List"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.accessibilityIdentifier = "ProductsList"

        // tap gesture to dimiss keyboard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        setUpSearchBar()

        // fetch/update from server on LocalDB
        getProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // fetch for offline from LocalDB
        getProductsFromLocal()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        searchBar.selectedScopeButtonIndex = 0
        searchBar.endEditing(true)
    }
}

// MARK: - General extension funcionality

extension ProductsTableViewController {
    // get fresh/update data from server and update the localDB
    func getProducts() {
        // start Loading progress
        showLoadingView(tableView)

        // get product data from server
        viewModel.getProductsData { error in
            self.hideLoadingView(self.tableView)

            if error != nil {
                // Show alert error message
                let errorMsg = error!.localizedDescription.split(separator: ":")[1]
                self.showErrorMessage(errorMsg.description)
            } else {
                self.getProductsFromLocal()
            }
        }
    }

    func getFilteredProductsFromDB(sortBy: String, inputText: String) {
        // start Loading progress
        showLoadingView(tableView)

        viewModel.getFilteredProductsData(sortBy, inputText) {
            // stop loading progress
            self.hideLoadingView(self.tableView)
            self.tableView.reloadData()
        }
    }

    func getSortedProductsFromDB(sortBy: String) {
        // start Loading progress
        showLoadingView(tableView)

        viewModel.getSortedProductsData(sortBy) {
            // stop loading progress
            self.hideLoadingView(self.tableView)
            self.tableView.reloadData()
        }
    }

    func refreshProducts() {
        // get fresh data from server and update the localDB
        getProducts()
    }

    func getProductsFromLocal() {
        // start Loading progress
        showLoadingView(tableView)

        // get data from Local DB(Core Data)
        viewModel.getFromLocalDB {
            // stop loading progress
            self.hideLoadingView(self.tableView)
            self.tableView.reloadData()
        }
    }

    // showImage on DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard
            segue.identifier == "ShowDetailSegue",
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController
        else {
            return
        }
        let product = viewModel.products?[indexPath.row]
        detailViewController.product = product
    }

    // show Image with SafariviewController
    func showImage1(atIndex indx: Int) {
        if let imageURL = viewModel.products?[indx].imageUrl {
            let safariController = SFSafariViewController(url: URL(string: imageURL)!)
            navigationController?.present(safariController, animated: true, completion: nil)
        }
    }
}

// MARK: - Search bar related

extension ProductsTableViewController: UISearchBarDelegate {
    // Setup SearchBar
    func setUpSearchBar() {
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name", "Price"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self

        tableView.tableHeaderView = searchBar
    }

    // searchBar textDidChange
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            getProducts()
            return
        }
        let sortType = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex].lowercased()
        // filter the product list
        getFilteredProductsFromDB(sortBy: sortType, inputText: searchText)
    }

    // SearchBar selectedScopeButtonIndexDidChange
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange _: Int) {
        let sortType = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex].lowercased()
        getSortedProductsFromDB(sortBy: sortType)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: - TableView related

extension ProductsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.products?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewCell.className, for: indexPath) as! ProductViewCell
        let product = viewModel.products?[indexPath.row]
        cell.updateData(item: product!)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // this can be used if wants to have full screen image load via safaricontroller.
        // showImage1(atIndex: indexPath.row)
    }

    func scrollViewWillEndDragging(_: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset _: UnsafeMutablePointer<CGPoint>) {
        searchBar.endEditing(true)

        UIView.animate(withDuration: 0.5, animations: {
            self.navigationController?.navigationBar.prefersLargeTitles = (velocity.y < 0)
        })
    }

    func scrollViewWillBeginDragging(_: UIScrollView) {
        // execute when you drag the scrollView
        searchBar.endEditing(true)
    }

    // pull to refresh changed then this will be called
    @IBAction func refreshControlValueChanged(_ sender: UIRefreshControl) {
        refreshProducts()
        sender.endRefreshing()
    }
}
