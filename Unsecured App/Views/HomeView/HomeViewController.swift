//
//  HomeViewController.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let movieLoading = MovieLoading()
    private var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Movies, Movie>?
    private var moviesSections = [Movies]()
    
    private let moviesNetworkManager = NetworkManager<MovieService, Movies>()
    private let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension HomeViewController {
    func setupView() {
        setupTitle()
        setupCollectionView()
    }
    
    func setupTitle() {
        title = "Filmy"
    }
    
    func setupCollectionView() {
        collectionView = .init(frame: .zero, collectionViewLayout: creatCompositionalLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 24, right: 0)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(MoviesCarouselCell.self, forCellWithReuseIdentifier: MoviesCarouselCell.reuseIdentifier)
        collectionView.register(MoviesBanerCell.self, forCellWithReuseIdentifier: MoviesBanerCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}

private extension HomeViewController {
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with movie: Movie, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        
        cell.configure(with: movie)
        return cell
    }
    
    func fetchData() {
        movieLoading.show(in: view)
        
        fetchNowPlayingMovies()
        fetchPopularMovies()
        fetchTopRatedMovies()
        fetchUpcomingMovies()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.movieLoading.dissmis()
            
            self?.moviesSections.sort { first, second in
                guard let firstType = first.getType(), let secondType = second.getType() else { return true }
                return firstType.rawValue < secondType.rawValue
            }
            
            self?.createDataSource()
            self?.reloadData()
        }
    }
    
    func fetchNowPlayingMovies() {
        dispatchGroup.enter()
        moviesNetworkManager.request(from: .nowPlaying(page: 1)) { [weak self] result in
            switch result {
            case .success(let nowPlayingMoviesResult):
                if nowPlayingMoviesResult.results.isEmpty { return }
                var nowPlayingMovies = nowPlayingMoviesResult
                nowPlayingMovies.setType(.nowPlaying)
                self?.moviesSections.append(nowPlayingMovies)
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    func fetchPopularMovies() {
        dispatchGroup.enter()
        moviesNetworkManager.request(from: .popular(page: 1)) { [weak self] result in
            switch result {
            case .success(let popularMoviesResult):
                if popularMoviesResult.results.isEmpty { break }
                var popularMovies = popularMoviesResult
                popularMovies.setType(.popular)
                self?.moviesSections.append(popularMovies)
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    func fetchTopRatedMovies() {
        dispatchGroup.enter()
        moviesNetworkManager.request(from: .topRated(page: 1)) { [weak self] result in
            switch result {
            case .success(let topRatedMoviesResult):
                if topRatedMoviesResult.results.isEmpty { break }
                var topRatedMovies = topRatedMoviesResult
                topRatedMovies.setType(.topRated)
                self?.moviesSections.append(topRatedMovies)
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    func fetchUpcomingMovies() {
        dispatchGroup.enter()
        moviesNetworkManager.request(from: .upcoming(page: 1)) { [weak self] result in
            switch result {
            case .success(let upcomingMoviesResult):
                if upcomingMoviesResult.results.isEmpty { return }
                var upcomingMovies = upcomingMoviesResult
                upcomingMovies.setType(.upcoming)
                self?.moviesSections.append(upcomingMovies)
            case .failure(let error):
                print(error)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Movies, Movie>(collectionView: collectionView) { [weak self] collectionView, indexPath, movie in
            guard let self = self else { return nil }
            switch self.moviesSections[indexPath.section].getType() {
            case .upcoming:
                return self.configure(MoviesBanerCell.self, with: movie, for: indexPath)
            case .nowPlaying, .popular, .topRated:
                return self.configure(MoviesCarouselCell.self, with: movie, for: indexPath)
            default:
                return nil
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return nil
            }
            guard let firstMovie = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstMovie) else { return nil }
            guard let type = section.getType() else { return nil }
            
            sectionHeader.configureView(with: .init(title: type.title, subtitle: type.subtitle))
            
            return sectionHeader
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Movies, Movie>()
        snapshot.appendSections(moviesSections)
    
        moviesSections.forEach { snapshot.appendItems($0.results, toSection: $0) }
        
        dataSource?.apply(snapshot)
    }
}

private extension HomeViewController {
    func creatCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            let section = self.moviesSections[sectionIndex]
            switch section.getType() {
            case .upcoming:
                return self.creatBannerSection(using: section)
            case .nowPlaying, .popular, .topRated:
                return self.createCarouselSection(using: section)
            default:
                return nil
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
    
        layout.configuration = config
        return layout
    }
    
    func creatBannerSection(using section: Movies) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = .init(top: 0.0, leading: 6.0, bottom: 0.0, trailing: 6.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalWidth(0.85 * 0.56222))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
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
    
    func createCarouselSection(using section: Movies) -> NSCollectionLayoutSection {
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

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedMovie = dataSource?.itemIdentifier(for: indexPath) else { return }
        navigationController?.pushViewController(MovieDetailsViewController(movie: selectedMovie), animated: true)
    }
}
