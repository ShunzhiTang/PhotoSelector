//
//  TSZPhotoSeletor.swift
//  PhotoSelector
//
//  Created by Tsz on 15/10/20.
//  Copyright © 2015年 Tsz. All rights reserved.
//

import UIKit

private let TSZPhotoSelectorIdentify = "TSZPhotoSelectorIdentify"
private let MaxNumberPriture = 9

class TSZPhotoSeletor: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册 cell
        collectionView?.registerClass(TSZPhotoSelectorCell.self, forCellWithReuseIdentifier: TSZPhotoSelectorIdentify)
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        //使用了 一种在内部设置cell的大小 ，定义布局的属性
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: 80, height: 80)
        //外边距
        layout?.sectionInset =  UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 实现UICollectionViewController 的数据源方法
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MaxNumberPriture
    }
    
   override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TSZPhotoSelectorIdentify, forIndexPath: indexPath) as! TSZPhotoSelectorCell
        cell.backgroundColor = UIColor.blueColor()
        return cell
    }
    
}

//MARK: - 实现从本机获取图片需要实现
extension TSZPhotoSeletor:UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    //根据api显示 一旦实现代理方法 需要  程序员去自己释放
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //图像统一缩放到300宽 , 为了考虑到内存的问题
        
        
//        let  imgScale = image.scaleIm
    }
    
    
}


//MARK: 自定我们需要的cell
private class TSZPhotoSelectorCell: UICollectionViewCell {
    /**
    * cell的图像
    */
    
    var image: UIImage? {
        didSet{
            //判断图片是否为空
            if  image == nil {
                addPhotoButton.setImage("compose_pic_add")
            }else{
                addPhotoButton.setImage(image, forState: UIControlState.Normal)
            }
        }
    }
    
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置 显示 UI
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 实现点击方法
    @objc func clickPhoto(){
        print("需要添加图片")
    }
    @objc func clickRemove(){
        print("删除")
    }
    
    
    private func setupUI(){
        addSubview(addPhotoButton)
        addSubview(removePhotoButton)
        
        //MARK: 显示 添加按钮的 自动布局
        addPhotoButton.translatesAutoresizingMaskIntoConstraints  = false
        removePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        //数组
        let dict = ["add" : addPhotoButton , "remove" : removePhotoButton]
        
        //布局
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[add]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
         addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[add]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[remove]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[remove]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        
        //MARK: 添加监听方法
        addPhotoButton.addTarget(self, action: "clickPhoto", forControlEvents: UIControlEvents.TouchUpInside)
        removePhotoButton.addTarget(self, action: "clickRemove", forControlEvents: UIControlEvents.TouchUpInside)
        //MARK: - 图片显示的不全，需要修改填充模式
        addPhotoButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    
    //MARK: 懒加载两个button
    private lazy var addPhotoButton:UIButton = UIButton(imageName: "compose_pic_add")
    
    private lazy var removePhotoButton:UIButton = UIButton(imageName: "compose_photo_close")
    
}
