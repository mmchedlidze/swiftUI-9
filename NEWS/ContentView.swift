//
//  ContentView.swift
//  NEWS
//
//  Created by Mariam Mchedlidze on 28.12.23.
//

import SwiftUI

struct NewsListView: UIViewRepresentable {
    let news: [News]
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        context.coordinator.news = news
        uiView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        var news: [News] = []
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return news.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            let newsItem = news[indexPath.row]
            cell.configure(with: newsItem)
            return cell
        }
    }
}

//MARK: - SwiftUI

struct ContentView: View {
    @State private var news: [News] = []
    
    var body: some View {
        VStack {
            NewsListView(news: news)
        }
        .onAppear {
            fetchNews()
        }
    }
    
    private func fetchNews() {
        NetworkManager.shared.fetchNews { result in
            switch result {
            case .success(let news):
                self.news = news
            case .failure(let error):
                print("Error fetching news: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Cell Configuration

class NewsCell: UITableViewCell {
    func configure(with news: News) {
        textLabel?.text = news.title
        textLabel?.numberOfLines = 2
        isAccessibilityElement = true
        accessibilityLabel = news.title
        textLabel?.font = .preferredFont(forTextStyle: .headline)
        detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
