//
//  MovieDetailsViewController.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 18/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

private extension MovieDetailsViewController {
    enum ViewType: Int {
        case backdropGallery = 0
        case details = 1
        case cast = 2
        case recommendationMovies = 3
    }
    
    struct ViewModel: Hashable {
        var title: String?
        var subtitle: String?
        var type: ViewType = .backdropGallery
        var views: [View]
    }
    
    struct View: Hashable {
        var backdrop: Backdrop?
        var movieDetails: MovieDetails?
        var cast: Cast?
        var movie: Movie?
    }
}

final class MovieDetailsViewController: UIViewController {
    
    private let movie: Movie
    
    private let movieLoading = MovieLoading()
    private var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<ViewModel, View>?
    private var sections = [ViewModel]()
    
    private let dispatchGroup = DispatchGroup()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
}

private extension MovieDetailsViewController {
    func setupView() {
        setupTitle()
        setupCollectionView()
    }
    
    func setupTitle() {
        title = movie.title
    }
    
    func setupCollectionView() {
        collectionView = .init(frame: .zero, collectionViewLayout: creatCompositionalLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 24, right: 0)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(MainHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHeader.reuseIdentifier)
        collectionView.register(BackdropBanerCell.self, forCellWithReuseIdentifier: BackdropBanerCell.reuseIdentifier)
        collectionView.register(CastCell.self, forCellWithReuseIdentifier: CastCell.reuseIdentifier)
        collectionView.register(MoviesCarouselCell.self, forCellWithReuseIdentifier: MoviesCarouselCell.reuseIdentifier)
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

private extension MovieDetailsViewController {
    func fetchData() {
        movieLoading.show(in: view)
        
        fetchImages()
        fetchDetails()
        fetchCredits()
        fetchRecommendations()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.movieLoading.dissmis()
            
            self?.sections.sort { $0.type.rawValue < $1.type.rawValue }
            
            self?.createDataSource()
            self?.reloadData()
        }
    }
    
    func fetchImages() {
        dispatchGroup.enter()
        let imagesNetworkManager = NetworkManager<MovieService, MoviesImages>()
        imagesNetworkManager.request(from: .images(movieId: movie.id)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moviesImages):
                let views = moviesImages.backdrops.map { View(backdrop: $0) }
                if views.isEmpty { break }
                var releaseDateString = ""
                if let releaseDate = Movie.releaseDateFormatter.date(from: self.movie.releaseDate) {
                    releaseDateString = "Premiera: \(Self.dateFormatter.string(from: releaseDate))"
                }
                let viewModel = ViewModel(title: self.movie.title, subtitle: releaseDateString, type: .backdropGallery, views: views)
                self.sections.append(viewModel)
            case .failure(let error):
                print(error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    func fetchDetails() {
        dispatchGroup.enter()
        let detailsNetworkManager = NetworkManager<MovieService, MovieDetails>()
        detailsNetworkManager.request(from: .details(movieId: movie.id)) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                let view = View(movieDetails: movieDetails)
                let viewModel = ViewModel(title: "Opis", type: .details, views: [view])
                if let overview = movieDetails.overview, !overview.isEmpty { self?.sections.append(viewModel) }
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    func fetchCredits() {
        dispatchGroup.enter()
        let creditsNetworkManager = NetworkManager<MovieService, Credits>()
        creditsNetworkManager.request(from: .credits(movieId: movie.id)) { [weak self] result in
            switch result {
            case .success(let credits):
                let views = credits.cast.map { View(cast: $0) }
                if views.isEmpty { break }
                let viewModel = ViewModel(title: "Obsada", type: .cast, views: views)
                self?.sections.append(viewModel)
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    func fetchRecommendations() {
        dispatchGroup.enter()
        let recommendationsNetworkManager = NetworkManager<MovieService, Movies>()
        recommendationsNetworkManager.request(from: .recommendations(movieId: movie.id)) { [weak self] result in
            switch result {
            case .success(let recommendationMovies):
                let views = recommendationMovies.results.map { View(movie: $0) }
                if views.isEmpty { break }
                let viewModel = ViewModel(title: "Rekomendowane", subtitle: "Podobne do \(self?.movie.title ?? "")", type: .recommendationMovies, views: views)
                self?.sections.append(viewModel)
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ViewModel, View>(collectionView: collectionView) { [weak self] collectionView, indexPath, view in
            guard let self = self else { return nil }
            switch self.sections[indexPath.section].type {
            case .backdropGallery:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropBanerCell.reuseIdentifier, for: indexPath) as? BackdropBanerCell else { fatalError("Unable to dequeue BackdropBanerCell") }
                if let backdrop = view.backdrop { cell.configure(with: backdrop) }
                return cell
            case .details:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.reuseIdentifier, for: indexPath) as? TextCell else { fatalError("Unable to dequeue TextCell") }
                if let movieDetails = view.movieDetails { cell.configure(with: movieDetails) }
                return cell
            case .cast:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.reuseIdentifier, for: indexPath) as? CastCell else { fatalError("Unable to dequeue CastCell") }
                if let cast = view.cast { cell.configure(with: cast) }
                return cell
            case .recommendationMovies:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCarouselCell.reuseIdentifier, for: indexPath) as? MoviesCarouselCell else { fatalError("Unable to dequeue MoviesCarouselCell") }
                if let movie = view.movie { cell.configure(with: movie) }
                return cell
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let firstView = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let viewModel = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstView) else { return nil }
            guard let title = viewModel.title else { return nil }
            
            switch viewModel.type {
            case .backdropGallery:
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainHeader.reuseIdentifier, for: indexPath) as? MainHeader else {
                    return nil
                }
                sectionHeader.configureView(with: .init(title: title, subtitle: viewModel.subtitle ?? ""))
                return sectionHeader
            case .recommendationMovies, .cast, .details:
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                    return nil
                }
                sectionHeader.configureView(with: .init(title: title, subtitle: viewModel.subtitle ?? ""))
                return sectionHeader
            }
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel, View>()
        snapshot.appendSections(sections)
        
        sections.forEach { snapshot.appendItems($0.views, toSection: $0) }
        
        dataSource?.apply(snapshot)
    }
}

private extension MovieDetailsViewController {
    func creatCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section.type {
            case .backdropGallery:
                return self.backdropGalllerySection(with: layoutEnvironment)
            case .details:
                return self.createDetailsSection()
            case .cast:
                return self.createCastSection()
            case .recommendationMovies:
                return self.createCarouselSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
    
        layout.configuration = config
        return layout
    }
    
    func backdropGalllerySection(with environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = .init(top: 0, leading: 6, bottom: 0, trailing: 6)

        let groupWidth = environment.container.contentSize.width * 0.92
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .absolute(groupWidth * 0.56222))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

        let sectionSideInset = (environment.container.contentSize.width - groupWidth) / 2
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sectionSideInset, bottom: 0, trailing: sectionSideInset)
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        layoutSectionHeader.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: -5)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]

        return layoutSection
    }
    
    func createDetailsSection() -> NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.estimated(300)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: layoutItem, count: 1)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = .init(top: 0, leading: 18, bottom: 0, trailing: 18)
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        layoutSectionHeader.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: -5)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    func createCastSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = .init(top: 0.0, leading: 4.0, bottom: 0.0, trailing: 4.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 4.4), heightDimension: .estimated(190))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        layoutSection.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        layoutSectionHeader.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: -5)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    func createCarouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = .init(top: 0.0, leading: 6.0, bottom: 0.0, trailing: 6.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalWidth(0.4 * 1.8))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        layoutSection.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        layoutSectionHeader.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: -5)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
}

private extension MovieDetailsViewController {
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pl-PL")
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedView = dataSource?.itemIdentifier(for: indexPath) else { return }
            
        if let selectedViewMovieModel = selectedView.movie {
            navigationController?.pushViewController(MovieDetailsViewController(movie: selectedViewMovieModel), animated: true)
        }
            
        if let selectedBackdrop = selectedView.backdrop, let imageURL = URL(string: "https://image.tmdb.org/t/p/original" + selectedBackdrop.filePath) {
            let imageViewer = ImageViewer(imageURL: imageURL)
            imageViewer.modalPresentationStyle = .pageSheet
            present(imageViewer, animated: true)
        }
            
        if let profilePath = selectedView.cast?.profilePath, let imageURL = URL(string: "https://image.tmdb.org/t/p/original" + profilePath) {
            let imageViewer = ImageViewer(imageURL: imageURL)
            imageViewer.modalPresentationStyle = .pageSheet
            present(imageViewer, animated: true)
        }
    }
}
