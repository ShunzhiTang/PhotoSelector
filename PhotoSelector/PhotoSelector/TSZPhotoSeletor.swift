//  TSZPhotoSeletor.swift
//  PhotoSelector
//  Created by Tsz on 15/10/20.
//  Copyright © 2015年 Tsz. All rights reserved.

import UIKit

private let TSZPhotoSelectorIdentify = "TSZPhotoSelectorIdentify"
private let MaxNumberPriture = 9

class TSZPhotoSeletor: UICollectionViewController ,PhotoSelectorViewDelegate{

    //照片的数组
    lazy var photos: [UIImage] = [UIImage]()
    // 当前用户选择照片的索引
    private var currentIndex = 0
    
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
        
        return  (photos.count == MaxNumberPriture) ? photos.count : photos.count + 1
    }
    
   override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TSZPhotoSelectorIdentify, forIndexPath: indexPath) as! TSZPhotoSelectorCell
        cell.backgroundColor = UIColor.blueColor()
    
    cell.image = (indexPath.item < photos.count) ? photos[indexPath.item] : nil
    
        cell.photoDelegate = self
        return cell
    }
    
    
    //MARK: 照片选择的 协议实现
    private func photoSelectorViewCellSelectorPhoto(cell: TSZPhotoSelectorCell) {
         print(__FUNCTION__)
        //一个参数默认就会删除参数名
        if  !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            print("无法访问图片库")
            return
        }
        
        //记录当前用户选中的索引
        let indexPath = collectionView?.indexPathForCell(cell)
        
        print(indexPath)
        
        currentIndex = indexPath!.item
        
        //实例化图片选择器
        let picker = UIImagePickerController()
        
        //自己实现自己的方法
        
        picker.delegate = self
        
        //设置允许编辑
        // 设置允许编辑 － 会多一个窗口，让用户缩放照片
        // 在实际开发中，如果让用户从照片库选择头像，非常重要！
        // 好处：1. 正方形，2. 图像会小
        
        picker.allowsEditing = true
        
        //跳转页面
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
      //MARK: 照片删除的 协议实现
    private func photoSelectorViewCellRemovePhoto(cell: TSZPhotoSelectorCell) {
        
        //找到对应的cell
        let indexPath = collectionView?.indexPathForCell(cell)
        photos.removeAtIndex(indexPath!.item)
        //刷新数据
        collectionView?.reloadData()
        
    }
}

//MARK: - 实现从本机获取图片需要实现
extension TSZPhotoSeletor:UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    //根据api显示 一旦实现代理方法 需要  程序员去自己释放
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //图像统一缩放到300宽 , 为了考虑到内存的问题
        
        let  imgScale = image.scaleImage(300)
        
        //当前的索引何照片的总数相等
        if currentIndex == photos.count{
            photos.append(imgScale)
        }else {
            //如果小于说明是数组中的某一项，
            photos[currentIndex] = imgScale
        }
        
        //更新collectionView
        collectionView?.reloadData()
        
        //记得一定要关闭
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}

//MARK:  点击我们的cell ，需要控制器去实现图片选择器
private protocol PhotoSelectorViewDelegate: NSObjectProtocol{
    /// MARK: 选择图片
    func photoSelectorViewCellSelectorPhoto(cell: TSZPhotoSelectorCell)
    
    //删除图片
    func photoSelectorViewCellRemovePhoto(cell: TSZPhotoSelectorCell)
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
            
            //MARK - 这一句隐藏删除按钮
             removePhotoButton.hidden  = (image == nil)
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
    
    // MARK: --- 给出一个接口去实现cell的 协议
    weak var photoDelegate: PhotoSelectorViewDelegate?
    
    // MARK: - 实现点击方法
    @objc func clickPhoto(){
        photoDelegate?.photoSelectorViewCellSelectorPhoto(self)
    }
    @objc func clickRemove(){
        photoDelegate?.photoSelectorViewCellRemovePhoto(self)
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
