//
//  DetailViewController.swift
//  Yelp
//
//  Created by Grace Egbo on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var largeBusinessImageView: UIImageView!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var snippetImageView: UIImageView!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        
        largeBusinessImageView.setImageWithURL(business.imageURL!)
        
        businessImageView.setImageWithURL(business.imageURL!)
        businessImageView.layer.cornerRadius = 3
        businessImageView.clipsToBounds = true
        
        ratingImageView.setImageWithURL(business.ratingImageURL!)
        
        snippetImageView.setImageWithURL(business.snippetImageUrl!)
        snippetImageView.layer.cornerRadius = 3
        snippetImageView.clipsToBounds = true
        
        snippetLabel.text = business.snippetText!
        snippetLabel.sizeToFit()
        
        titleLabel.text = business.name!
        
        distanceLabel.text = business.distance!
        
        reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        
        addressLabel.text = business.address!
        
        descriptionLabel.text = business.categories
        
        phoneLabel.text = "Call \(business.phoneNumber!)"
        
        let centerLocation = CLLocation(latitude: Double(business.latitude!), longitude: Double(business.longitude!))
        goToLocation(centerLocation)
        
        let centerLocationCoordinate = CLLocationCoordinate2D(latitude: Double(business.latitude!), longitude: Double(business.longitude!))
        addAnnotationAtCoordinate(centerLocationCoordinate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }

    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = titleLabel.text
        mapView.addAnnotation(annotation)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
