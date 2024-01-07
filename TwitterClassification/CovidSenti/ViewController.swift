//
//  ViewController.swift
//  CovidSenti

import UIKit
import CoreML
import SwifteriOS
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var getPrediction: UIButton!
    
    
    
    let sentimentClassifer = TweetSentimentClassifier()
    
    // this API key will be initialized using a consumer key and consumer secret, which are HIDDEN FOR THE PURPOSE OF PRIVACY
    let swifter = Swifter(consumerKey: "NlUbmj7wcdHBCDK0sFVGAmslX", consumerSecret: "4CjsgS0MTHrXNtzrAO7Q56vuFV8iEYD8bTCDrch1A2MrDgQeGV")
    
    // when the MLmodel was created, a separate class was also created to use the model's properties & extensions

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        if let searchInText = textField.text {
              
            /*
            // Do any additional setup after loading the view.
            // 'using' is the search query string
            // 'success' returns the two callback objects, upon a successful query
            // first object under success is the actual results in JSON
            // the second object under success is the metadata produced regarding the first object (the actual results)
            // 'failure' handler gives you the result of what might be the result of a failed query
            // 'count' parameter, set to 100 in this case, fetches 100 tweets per topic searched
            // inclusion of the parameter 'tweetMode' will extract the extended version of the tweet
            */
                     
            swifter.searchTweet(using: searchInText, lang: "en", count: 100, tweetMode: .extended, success: { (results, theMetadata) in
                         
            // formerly was [String]() -> transformed to '[TweetSentimentClassifierInput]()' to store multiple data types in one
                        
            var tweets = [TweetSentimentClassifierInput]()
                    for i in 0..<100 {
                        // passing the results to the variable 'tweet'
                        if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                            }
                         }
                         
                    do {
                        let thePredictions = try self.sentimentClassifer.predictions(inputs:tweets)
                        
                        // initialize the sentiment score of the tweets to zero; calculations will then be performed based on neutral, positive or negative feedback
                            
                        var sentimentScore = 0
                             
                        for aSinglePrediction in thePredictions {
                        // print(onePrediction.label) -> only necessary for the programmer...
                                
                        let sentiment = aSinglePrediction.label
                                 
                        if sentiment == "Pos" {
                            sentimentScore += 1
                        } else if sentiment == "Neg" {
                            sentimentScore -= 1
                        } else if sentiment == "Neutral" {
                            sentimentScore += 0
                        } else { print("Hey we have an error here!") }
                            }
                
                        if sentimentScore > 20 {
                            self.sentimentLabel.text = "Outstanding"
                            
                        } else if sentimentScore > 10 {
                            self.sentimentLabel.text = "Superb"
                            
                        } else if sentimentScore > 0 {
                            self.sentimentLabel.text = "Above Average"
                            
                        } else if sentimentScore == 0 {
                            self.sentimentLabel.text = "OK"
                            
                        } else if sentimentScore > -10 {
                            self.sentimentLabel.text = "Somewhat Bad"
                            
                        } else if sentimentScore > -20 {
                            self.sentimentLabel.text = "Poor"
                            
                        } else {
                            self.sentimentLabel.text = "Abysmal"
            
                        }
                        
                        } catch {
                            print("There was an error in the process of making a prediction and the error is this: \(error)")
                         }
                         
                         
                     }) { (error) in print("ERROR with the API request. Suggests alternatives.") }
         }
        
    }
    
}

