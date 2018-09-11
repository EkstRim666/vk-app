//
//  GroupTableViewCell.swift
//  vk-app
//
//  Created by Andrey Yusupov on 27/08/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView! {
        didSet {
            avatar.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var name: UILabel! {
        didSet {
            name.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private let instets: CGFloat = 5.0
    private let avatarSideLenght: CGFloat = 50.0
    
    private func avatarFrame() {
        let avatarSize = CGSize(width: avatarSideLenght, height: avatarSideLenght)
        let avatarOrigin = CGPoint(x: bounds.minX + instets, y: bounds.midY - avatarSideLenght / 2)
        avatar.frame = CGRect(origin: avatarOrigin, size: avatarSize)
    }
    
    private func getLableSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - instets * 3 - avatarSideLenght
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    private func nameLableframe() {
        guard let text = name.text
            else { return }
        let nameLableSize = getLableSize(text: text, font: name.font)
        let nameLabelX = bounds.minX + avatarSideLenght + 2 * instets
        let nameLabelY = bounds.midY - nameLableSize.height / 2
        let nameLabelOrigin = CGPoint(x: nameLabelX, y: nameLabelY)
        name.frame = CGRect(origin: nameLabelOrigin, size: nameLableSize)
    }
    
    func setName(text: String) {
        name.text = text
        nameLableframe()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarFrame()
        nameLableframe()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatar.image = nil
        name.text = nil
    }
}
