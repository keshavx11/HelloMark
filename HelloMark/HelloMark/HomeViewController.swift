//
//  HomeViewController.swift
//  HelloMark
//
//  Created by Keshav Bansal on 21/01/17.
//  Copyright © 2017 HelloMark. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    var isReady: Bool = false
    
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.startButton.layer.cornerRadius = 8.0
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 4, height: self.scrollView.frame.height)
        self.scrollView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        self.details(self.pageControl.currentPage)
    }
    
    @IBAction func pageChange(){
        let currentPage = pageControl.currentPage
        scrollView.contentOffset.x = (self.view.frame.width * CGFloat(currentPage))
        self.details(currentPage)
    }
    
    func details(_ currentPage: Int){
        if Int(currentPage) == 0{
            label.text = "Bedroom"
            textView.text = "AB"
            imageView.image = UIImage(named: "face1.png")
        }else if Int(currentPage) == 1{
            label.text = "Kitchen"
            textView.text = "AB"
            imageView.image = UIImage(named: "face2.png")
        }else if Int(currentPage) == 2{
            label.text = "Living Room"
            textView.text = "AB"
            imageView.image = UIImage(named: "face1.png")
        }else if Int(currentPage) == 3{
            label.text = "Washroom"
            textView.text = "AB"
            imageView.image = UIImage(named: "face2.png")
        }
        
    }
    
    @IBAction func next(){
    }
}

