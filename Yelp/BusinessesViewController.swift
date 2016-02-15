//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,UIScrollViewDelegate
{
    @IBOutlet weak var tableView: UITableView!

    var businesses: [Business]!
    var searchBar: UISearchBar!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var offsetAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the tableview
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        //set up the searchbar
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
/*        Business.searchWithTerm("", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
      })
 */
        //Example of Yelp search with more search options specified
        Business.searchWithTerm("", sort: nil, categories: nil, deals: nil, offset: offsetAmount) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.tableView.reloadData()
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if businesses != nil{
            return businesses.count
        }
        return 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) // called when text starts editing
    {
        //print("Started editing")
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) // called when cancel button pressed
    {
    
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
   }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) // called when keyboard search button pressed
    {
        print(searchBar.text!)
        Business.searchWithTerm(searchBar.text!, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        searchBar.text = nil //sets text back to a blank state
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) // any offset changes
    {
        if (!isMoreDataLoading)
        {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                loadMoreData()
            }

        }
    }
    
    func loadMoreData()
    {
        // ... Use the new data to update the data source ...
        offsetAmount = offsetAmount + 20
        Business.searchWithTerm(searchBar.text!, sort: nil, categories: nil, deals: nil, offset: offsetAmount, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses.appendContentsOf(businesses)
        
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            // Update flag
            self.isMoreDataLoading = false
        })

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! BusinessCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let business = businesses[indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        detailViewController.business = business
    }
    

}
