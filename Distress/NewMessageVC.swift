//
//  NewMessageVC.swift
//  Distress
//
//  Created by Michael Litman on 12/7/15.
//  Copyright © 2015 awesomefat. All rights reserved.
//

import UIKit
import Parse


class NewMessageVC: UIViewController
{
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var phoneTF: UITextField!

    @IBOutlet weak var nameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButtonPressed(sender: AnyObject)
    {
        var message = ""
        
        if(self.nameTF.text!.characters.count == 0)
        {
            message = "You must enter a name"
        }
        else if(self.phoneTF.text!.characters.count == 0)
        {
            message = "You must enter a phone number"
        }
        else if(self.messageTV.text!.characters.count == 0)
        {
            message = "You must enter a message"
        }
        self.sendSMS(messageTV.text)
        if(message.characters.count == 0)
        {
            //we can create the Message
            self.sendSMS(messageTV.text)
            let obj = PFObject(className: "Message")
            obj.setValue(nameTF.text, forKey: "name")
            obj.setValue(phoneTF.text, forKey: "phone")
            obj.setValue(messageTV.text, forKey: "message_text")
            obj.setValue(PhoneCore.currentUser, forKey: "owner_id")
            obj.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if(success)
                {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else
                {
                    PhoneCore.showAlert("Message Create Error", message: "Something went wrong during save!!!!", presentingViewController: self, onScreenDelay: 2.0)
                }
            })
        }
        else
        {
            //show the error
            PhoneCore.showAlert("Message Create Error", message: message, presentingViewController: self, onScreenDelay: 2.0)
        }

    }
    
    func sendSMS(message : String)
    {
        
        let twilioSID = "SK61135d164d9d775e839b6669ccd7d00f"
        let twilioSecret = "2bFuR2wH8VknuCRgaPCTdDRAkj7zgdBG"
        
        //Note replace + = %2B , for To and From phone number
        let fromNumber = "%2B12172574737"// actual number is +14803606445
        let toNumber = "%2B12172571781"// actual number is +919152346132
        //let request = NSMutableURLRequest(URL: NSURL(string:"https://api.twilio.com/2010-04-01/Accounts/\(twilioSID)/Messages?To=\(toNumber)")!)
        //let request = NSMutableURLRequest(URL: NSURL(string:"https://api.twilio.com/2010-04-01/Accounts/\(twilioSID)/Messages")!)
        let request = NSMutableURLRequest(URL: NSURL(string:"https://api.twilio.com/2010-04-01/Accounts/\(twilioSID):\(twilioSecret)/Messages")!)
        // Build the request
        //let request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/Messages")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
        
        // Build the completion block and send the request
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
