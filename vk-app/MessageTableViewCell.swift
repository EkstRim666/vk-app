//
//  MessageTableViewCell.swift
//  vk-app
//
//  Created by Andrey Yusupov on 08/09/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageText: UILabel! {
        didSet {
            messageText.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private static var height: CGFloat = 0
    private var message: Message?
    private let instetsShowWhoseMessage: CGFloat = 100
    private let instets: CGFloat = 5
    
    static func getHeight() -> CGFloat {
        return MessageTableViewCell.height
    }
    
    func setMessage(message: Message) {
        self.message = message
        setMessageText()
    }
    
    private func setMessageText() {
        messageText.text = message?.text
        messageLabelFrame()
    }
    
    private func messageLabelFrame() {
        guard let text = messageText.text
            else { return }
        let messageLabelSize = getLableSize(text: text, font: messageText.font)
        guard let message = message
            else { return }
        if message.fromId == Service.getUserId() {
            let messageLabelX = bounds.minX + instetsShowWhoseMessage
            let messageLabelY = bounds.midY - messageLabelSize.height / 2
            let messageLabelOrigin = CGPoint(x: messageLabelX, y: messageLabelY)
            messageText.frame = CGRect(origin: messageLabelOrigin, size: messageLabelSize)
        } else {
            let messageLabelX = bounds.minX + instets
            let messageLabelY = bounds.midY - messageLabelSize.height / 2
            let messageLabelOrigin = CGPoint(x: messageLabelX, y: messageLabelY)
            messageText.frame = CGRect(origin: messageLabelOrigin, size: messageLabelSize)
        }
    }
    
    private func getLableSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - instets - instetsShowWhoseMessage
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let wight = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(wight), height: ceil(height))
        MessageTableViewCell.height = CGFloat(ceil(height)) + instets * 2
        return size
    }
    
    
}
