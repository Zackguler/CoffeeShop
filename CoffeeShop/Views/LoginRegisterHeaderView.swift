//
//  LoginRegisterHeaderView.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit

class LoginRegisterHeaderView: UIView {
    
    private let labelTitle : UILabel
    public let labelSubTitle : UILabel
    private let viewSubtitles : UIView
    
    init(title:String, subTitle:String, showButtonDetail:Bool=true, buttonDetailTitle:String="") {
        
        self.labelTitle = UILabel()
        self.labelTitle.text = title
        self.labelTitle.font = UIFont.fontBold24
        self.labelTitle.textAlignment = .center
        self.labelTitle.textColor = Colors().colorDarkGray
        self.labelTitle.numberOfLines = 0
        
        self.viewSubtitles = UIView()
        
        self.labelSubTitle = UILabel()
        self.labelSubTitle.text = subTitle
        self.labelSubTitle.font = UIFont.fontRegular14
        self.labelSubTitle.textAlignment = .center
        self.labelSubTitle.numberOfLines = 0
        self.labelSubTitle.textColor = Colors().colorDarkGray
        
        if showButtonDetail {
            self.labelSubTitle.setDoubleFont(text1: subTitle,
                                             font1: UIFont.fontRegular14,
                                             color1: Colors().colorDarkGray,
                                             text2: buttonDetailTitle,
                                             font2: UIFont.fontBold14,
                                             color2: Colors().colorDarkGray)
        }
        
        super.init(frame: CGRect.zero)
        
        self.initViews()
    
        self.setupConstraints()
        
    }
    
    private func initViews() {
        backgroundColor = .clear
        clipsToBounds = true
        
        viewSubtitles.addSubview(labelSubTitle)
        
        addSubview(labelTitle)
        addSubview(viewSubtitles)
        
    }
    
    private func setupConstraints() {
        
        labelTitle.snp.makeConstraints {[weak self] (make) in
            guard let self = self else { return }
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.viewSubtitles.snp.top).offset(14.0)
        }
        
        viewSubtitles.snp.makeConstraints { (make) in
            make.height.equalTo(42)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        labelSubTitle.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not implemented")
    }
}
