
import UIKit


class LegoPartsListTableViewCell: UITableViewCell {
    

    var mainStackView: UIStackView = {
       
        let stackView = UIStackView()
        
        stackView.spacing = 8
        stackView.alignment = .top
        
        return stackView
    }()
    
    
    var mainImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        return imageView
    }()
    
    
    var mainLabel: UILabel = {
       
        let label = UILabel()
        
        label.numberOfLines = 0
        
        return label
    }()
    
    
    convenience init(reuseIdentifier: String?) {
        self.init(style: .default, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(mainStackView)

        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(mainLabel)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            mainStackView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            
            mainImageView.widthAnchor.constraint(equalTo: mainImageView.heightAnchor, multiplier: 1),
        ])
        
        let imageViewHeightConstraint = mainImageView.heightAnchor.constraint(equalToConstant: 180)
        imageViewHeightConstraint.priority = .defaultLow
    }
    
    
    var imageDownloadDataTask: URLSessionDataTask?
    
    
    var imageURL: URL? {
        
        didSet {
            
            imageDownloadDataTask?.cancel()
            
            self.mainImageView.image = nil
            
            if imageURL != nil {
                
                imageDownloadDataTask = URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
                    
                    guard error == nil, let data = data else {
                        
                        return
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.mainImageView.image = UIImage(data: data)
                    }
                    
                }
                    
                imageDownloadDataTask!.resume()
            }
        }
    }
    
    
    override func prepareForReuse() {

        imageDownloadDataTask?.cancel()
        
        mainImageView.image = nil
    }
}
