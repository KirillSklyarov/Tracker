import UIKit
import PlaygroundSupport

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}

final class ColorCell: UICollectionViewCell {
    
    static let identifier = "ColorCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class SupplementaryCollection: NSObject, UICollectionViewDataSource {
    
    private var colors = [UIColor]()
//    = [
//        .black, .blue, .brown,
//        .cyan, .green, .orange,
//        .red, .purple, .yellow
//    ]
    
    private let collection: UICollectionView
    
    private let params: GeometricParams
    
    init(using params: GeometricParams, collection: UICollectionView) {
        self.params = params
        self.collection = collection
        
        super.init()
    }

    func add(colors values: [UIColor]) {
        guard !values.isEmpty else { return }
        
        let count = colors.count
        colors = colors + values
        
        collection.performBatchUpdates {
            let indexes = (count..<colors.count).map { IndexPath(row: $0, section: 0) }
            collection.insertItems(at: indexes)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
        
        cell.prepareForReuse()
        cell.contentView.backgroundColor = colors[indexPath.row]
        return cell
    }
}

extension SupplementaryCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWight = collectionView.frame.width - params.paddingWidth
        let cellWight = availableWight / CGFloat(params.cellCount)
        return CGSize(width: cellWight, height: cellWight * 2/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: params.leftInset, bottom: 10, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
}


    
let size = CGRect(x: 0, y: 0, width: 400, height: 400)
let view = UIView(frame: size)
let params = GeometricParams(cellCount: 3,
                             leftInset: 10,
                             rightInset: 10,
                             cellSpacing: 10)

let layout = UICollectionViewFlowLayout()
let collection = UICollectionView(frame: size, collectionViewLayout: layout)
collection.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(collection)
collection.backgroundColor = .white
PlaygroundPage.current.liveView = view

let helper = SupplementaryCollection(using: params, collection: collection)
let addButton = UIButton(type: .roundedRect, primaryAction: UIAction(title: "Add color", handler: { [weak helper] _ in
    
    let colors: [UIColor] = [
            .black, .blue, .brown,
            .cyan, .green, .orange,
            .red, .purple, .yellow
        ]
    let selectedColors = (0..<2).map {_ in colors[Int.random(in: 0..<colors.count)] }
    helper?.add(colors: selectedColors)
})
)

addButton.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(addButton)

NSLayoutConstraint.activate([
    collection.topAnchor.constraint(equalTo: view.topAnchor),
    collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    collection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
    
    addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    addButton.heightAnchor.constraint(equalToConstant: 30)
])



    

