//    MIT License
//
//    Copyright (c) ( https://github.com/liangdahong )
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

import UIKit

private var UITableViewCellHeightKey = 0

private extension UIView {
    func layoutGetFrame() {
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.setNeedsDisplay()
    }
}

extension UITableView {

    func cellHeight<T: UITableViewCell>(cellClass clas: T.Type,
                                        style: UITableViewCell.CellStyle = .default,
                                        configuration: (T)->() ) -> CGFloat {
        
        var dict = objc_getAssociatedObject(self, &UITableViewCellHeightKey) as? [String : UIView]
        if dict == nil {
            dict = [String : UIView]()
        }

        let className = NSStringFromClass(clas)

        var view: UIView? = dict?[className]
        
        if view == nil {
            let path = Bundle.main.path(forResource: String(className.split(separator: ".").last!), ofType: "nib")
            view = UIView()
            var cell: T?
            if let _ = path {
                cell = Bundle.main.loadNibNamed(String(className.split(separator: ".").last!), owner: nil, options: nil)?.first as?  T
            } else {
                cell = clas.init(style: style, reuseIdentifier: nil)
            }
            view!.addSubview(cell!)
            dict?[className] = view
            objc_setAssociatedObject(self, &UITableViewCellHeightKey, dict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        if let v = view, let cell: T = v.subviews.first as? T {

            let tempView : UIView = self.superview != nil ? self.superview! : self

            tempView.layoutGetFrame()

            v.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.0)
            cell.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.0)
            
            configuration(cell)

            v.layoutGetFrame()
            
            return cell.contentView.subviews.max {$0.frame.maxY < $1.frame.maxY}?.frame.maxY ?? 0.0
        } else {
            return 0.0
        }
    }
}
