//
//  ViewController.swift
//  DynamicGradient
//
//  Created by Matt McEachern on 12/21/15.
//  Copyright © 2015 Matt McEachern. All rights reserved.
//

import UIKit

private let MENU_INSETS: CGFloat = 75.0
private let NUMBER_OF_PAGES = 4

class ViewController: UIViewController, UIScrollViewDelegate {
    
    
    private var background: DynamicGradient!
    private var pageControl: UIPageControl!
    private var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding NSNotificationCenter observers to add events for when the app becomes active/inactive
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        /*----------Dynamic Background----------*/
        
        self.background = DynamicGradient(frame: self.view.bounds)
        self.view.addSubview(background)
        
        
        /*----------Generic Scroll Menu---------*/
        
        self.scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(NUMBER_OF_PAGES), height: self.view.bounds.height)
        scrollView.pagingEnabled = true
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50.0))
        self.view.addSubview(pageControl)
        pageControl.center = CGPoint(x: self.view.center.x, y: self.view.bounds.height - 50.0)
        pageControl.numberOfPages = NUMBER_OF_PAGES
        pageControl.currentPage = 0
        
        // adding some menu items
        for i in 0..<(NUMBER_OF_PAGES-1) {
            addMenuItem(CGFloat(i) * self.view.bounds.width)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Utility
    
    // adds a generic, translucent menu box to the scroll view at the given offset
    private func addMenuItem(xOffset: CGFloat) {
        let x = xOffset + MENU_INSETS
        let y = 2.5 * MENU_INSETS
        let width = self.view.bounds.width - 2 * MENU_INSETS
        let height = self.view.bounds.height - 5 * MENU_INSETS
        let menuItem = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        
        // translucent backrgound
        menuItem.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.25)
        
        // gray border
        menuItem.layer.borderColor = UIColor.lightGrayColor().CGColor
        menuItem.layer.borderWidth = 2.0
        menuItem.layer.cornerRadius = 5.0
        
        self.scrollView.addSubview(menuItem)
    }
    
    // MARK: NSNotificationCenter event handlers
    
    func appDidBecomeActive(notification: NSNotification) {
        background.startAnimtating()
    }
    
    func appDidEnterBackground(notification: NSNotification) {
        background.stopAnimating()
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let currentPage = Int(floor(xOffset / self.view.bounds.width))
        self.pageControl.currentPage = currentPage
        
    }
}

