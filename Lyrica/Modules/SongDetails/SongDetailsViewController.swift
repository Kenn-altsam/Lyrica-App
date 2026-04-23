
import UIKit

class SongDetailsViewController: UIViewController {
    
    // Mark: - Properties
    private let viewModel: SongDetailsViewModel
    private let songDetailsView = SongDetailsView()
    
    // Mark: - Init
    init(viewModel: SongDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    // Mark: - Lifecycle
    override func loadView() {
        view = songDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad( )
        title = viewModel.title
        configure()
    }
    
    // Mark: - Setup
    private func configure() {
        songDetailsView.titleLabel.text = viewModel.title
        songDetailsView.lyricsTextView.text = viewModel.lyrics
        songDetailsView.dateLabel.text = viewModel.formattedDate
        songDetailsView.priceLabel.text = viewModel.formattedPrice
    }
    
}
