//
//  ViewController.swift
//  ChatTry
//
//  Created by PanaCloud on 30/03/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class ViewController: JSQMessagesViewController,JSQMessagesCollectionViewDelegateFlowLayout,JSQMessagesCollectionViewDataSource{
    
    var demoData:DemoModelData!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title="Chat Messages"
        
       
        
        //Change this for Custom Model
        self.demoData=DemoModelData()
        
        
        
        //Change this for custom Avatar Sizes
        if(!NSUserDefaults.standardUserDefaults().boolForKey("incomingAvatarSetting")){
            self.collectionView.collectionViewLayout.incomingAvatarViewSize=CGSizeZero
        }
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("outgoingAvatarSetting")){
            self.collectionView.collectionViewLayout.outgoingAvatarViewSize=CGSizeZero
        }
        
        
        //Change this for show Earlier Messages Header
        self.showLoadEarlierMessagesHeader = false
        
        
        //Right bar button item Action
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Receive", style: UIBarButtonItemStyle.Done, target: self, action: "receiveMessagePressed:")
        
        
        /**
        *  Customize your toolbar buttons
        *
        *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
        *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
        */
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        //Left bar button Action
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "closePresses")
        
        
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        //Change to enable springiness
        self.collectionView.collectionViewLayout.springinessEnabled=false
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        /**
        *  Sending a message. Your implementation of this method should do *at least* the following:
        *
        *  1. Play sound (optional)
        *  2. Add new id<JSQMessageData> object to your data source
        *  3. Call `finishSendingMessage`
        */
        
        //Play sound
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        //Add object to data source
        var message=JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.demoData.messages.addObject(message)
        
        self.finishSendingMessageAnimated(true)
        
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        var sheet = UIAlertController(title: "Media Messages", message: "Please select a media", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert: UIAlertAction!) -> Void in
            sheet.dismissViewControllerAnimated(true, completion: nil)
        }
        
        var sendPhoto = UIAlertAction(title: "Send Photo", style: UIAlertActionStyle.Default){ (alert: UIAlertAction!) -> Void in
            self.demoData.addPhotoMediaMessage()
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            self.finishSendingMessageAnimated(true)
        }
        
        var sendVideo = UIAlertAction(title: "Send Video", style: UIAlertActionStyle.Default){ (alert: UIAlertAction!) -> Void in
            self.demoData.addVideoMediaMessage()
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            self.finishSendingMessageAnimated(true)
        }
        
        var sendLocation = UIAlertAction(title: "Send Location", style: UIAlertActionStyle.Default){ (alert: UIAlertAction!) -> Void in
            self.demoData.addLocationMediaMessageCompletion({
                self.collectionView.reloadData()
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.finishSendingMessageAnimated(true)
            })
        }


        sheet.addAction(sendPhoto)
        sheet.addAction(sendVideo)
        sheet.addAction(sendLocation)
        sheet.addAction(cancel)
        
        
        
        
        presentViewController(sheet, animated: true, completion: nil)
        ////////////Add shwt actions later
        
    }
    
   

    
    
    //Sets sender Id and Display Name
    func senderId() -> String! {
            return "daniyal11"
    }
    
    func senderDisplayName() -> String! {
            return "Daniyal Raza"
    }
    
    
   
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessageData
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var message:JSQMessage=self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessage
        
        if(message.senderId==self.senderId()){
            return self.demoData.outgoingBubbleImageData
        }
        
        return self.demoData.incomingBubbleImageData
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        /**
        *  Return `nil` here if you do not want avatars.
        *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
        *
        *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
        *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        *
        *  It is possible to have only outgoing avatars or only incoming avatars, too.
        */
        
        /**
        *  Return your previously created avatar image data objects.
        *
        *  Note: these the avatars will be sized according to these values:
        *
        *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
        *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
        *
        *  Override the defaults in `viewDidLoad`
        */
        
        var message:JSQMessage=self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessage
        
        if(message.senderId==self.senderId()){
            if(!NSUserDefaults.standardUserDefaults().boolForKey("outgoingAvatarSetting")){
                return nil
            }
        }
        else{
            if(!NSUserDefaults.standardUserDefaults().boolForKey("incomingAvatarSetting")){
                return nil
            }
        }
        
        var imageDict=self.demoData.avatars as NSDictionary
        
        return imageDict.objectForKey(message.senderId) as JSQMessageAvatarImageDataSource
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        /**
        *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
        *  The other label text delegate methods should follow a similar pattern.
        *
        *  Show a timestamp for every 3rd message
        */
        
        if(indexPath.item%3==0){
            var message:JSQMessage=self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessage
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        var message:JSQMessage=self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessage
        if(message.senderId==self.senderId()){
            return nil
        }
        
        if(indexPath.item-1>0){
            var previousMessage:JSQMessage=self.demoData.messages.objectAtIndex(indexPath.item-1) as JSQMessage
            if(previousMessage.senderId==message.senderId){
                return nil
            }
        }
        
        return NSAttributedString(string:message.senderDisplayName)
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.demoData.messages.count
    }
  
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        /**
        *  Configure almost *anything* on the cell
        *
        *  Text colors, label text, label colors, etc.
        *
        *
        *  DO NOT set `cell.textView.font` !
        *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
        *
        *
        *  DO NOT manipulate cell layout information!
        *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
        */
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        
        let message:JSQMessage = self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessage
        
        if(!message.isMediaMessage){
        
        if message.senderId == self.senderId() {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
    }
        return cell
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if(indexPath.item%3==0){
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        let currentMessage:JSQMessage = self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessage
        
        // Sent by me, skip
        if currentMessage.senderId == self.senderId() {
            return CGFloat(0.0);
        }
        
        if(indexPath.item-1>0){
            var previousMessage:JSQMessage = self.demoData.messages.objectAtIndex(indexPath.item-1) as JSQMessage
            if(previousMessage.senderId==currentMessage.senderId){
                return CGFloat(0.0)
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return CGFloat(0.0)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        println("Load Earlier Messages")
    }
    
//    var demoData:DemoModelData!
//
//
//
//    func senderId() -> String! {
//        return "daniyal11"
//    }
//
//    func senderDisplayName() -> String! {
//        return "Daniyal Raza"
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        self.title="Chat Practice"
//        self.senderId="daniyal11"
//        self.senderDisplayName="Daniyal Raza"
//        
//        self.demoData=DemoModelData()
//        
//       
//        
//       
//        
//        
//        
//        self.showLoadEarlierMessagesHeader = true
//        
////        if(!NSUserDefaults.standardUserDefaults().boolForKey("incomingAvatarSetting")){
////            self.collectionView.collectionViewLayout.incomingAvatarViewSize=CGSizeZero
////        }
////        
////        
////        if(!NSUserDefaults.standardUserDefaults().boolForKey("outgoingAvatarSetting")){
////            self.collectionView.collectionViewLayout.outgoingAvatarViewSize=CGSizeZero
////        }
//        
//        
//        
//        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Receive", style: UIBarButtonItemStyle.Done, target: self, action: "receiveMessagePressed:")
//        
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        
//        
//    }
//    
//   
//    
//    func receiveMessagePressed(){
//        self.showTypingIndicator = !self.showTypingIndicator
//        
//        
//        
//        self.scrollToBottomAnimated(true)
//        
//        var copyMessage=self.demoData.messages.lastObject?.copy()
//        
//        if((copyMessage) != nil){
//            copyMessage=JSQMessage(senderId: "Saad93", displayName: "Saad Umar", text: "New Message")
//            
//        }
//        
//    }
//    
//    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
//        
//        
//        
//        
//        
//        var message=JSQMessage(senderId: "Daniyal11", senderDisplayName: "Daniyal Raza", date: date, text: text)
//        self.demoData.messages.addObject(message)
//        self.finishSendingMessageAnimated(true)
////        
////        var sheet=UIAlertController(title: "Media Messages", message: "Select a media", preferredStyle:UIAlertControllerStyle.ActionSheet)
////        sheet.addAction(UIAlertAction(title: <#String#>, style: <#UIAlertActionStyle#>, handler: <#((UIAlertAction!) -> Void)!##(UIAlertAction!) -> Void#>))
//        
//        
//        
//    }
//    
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
//        var message:JSQMessageData=self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessageData
//        
//        return message
//    }
//   
//    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
//       
//        var message:JSQMessage=self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessage
//        
//        if(message.senderId==self.senderId){
//            return self.demoData.outgoingBubbleImageData
//        }
//        
//        return self.demoData.incomingBubbleImageData
//        
//        
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
//        return nil
//    }
//    
//    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.demoData.messages.count
//    }
//    
//    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
////        var cell:JSQMessagesCollectionViewCell=super.collectionView.cellForItemAtIndexPath(indexPath) as JSQMessagesCollectionViewCell
//        
////        var cell:JSQMessagesCollectionViewCell=collectionView.cellForItemAtIndexPath(indexPath) as JSQMessagesCollectionViewCell!
//        
//        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
//        
//        var message:JSQMessage=self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessage
//        if(message.senderId==self.senderId){
//            cell.textView.textColor=UIColor.blackColor()
//        }
//        else{
//            cell.textView.textColor=UIColor.whiteColor()
//        }
//        
//        
//        return cell
//        
////        cell.textView.linkTextAttributes=[NSForegroundColorAttributeName.,NSUnderlineStyleAttributeName=NSUnderlineStyle.StyleSingle]
//        
//        
//        
//    }
//    
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
//        if(indexPath.item%3==0){
//            var message:JSQMessage=self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessage
//            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
//        }
//        
//        return nil
//    }
//    
//
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
//        var message:JSQMessage=self.demoData.messages.objectAtIndex(indexPath.item) as JSQMessage
//        if(message.senderId==self.senderId){
//            return nil
//        }
//        if(indexPath.item-1>0){
//            var previousMessage:JSQMessage=self.demoData.messages.objectAtIndex(indexPath.item-1) as JSQMessage
//            if(previousMessage.senderId==message.senderId){
//                return nil
//            }
//        }
//        return NSAttributedString(string: message.senderDisplayName)
//        
//    }
//    
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
//        return nil
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//

}

