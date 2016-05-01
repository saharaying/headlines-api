namespace :feed do
  desc 'update feed channels'
  task update_channels: :environment do
    feed_urls = %w(
      http://nationalgeographicphotos.tumblr.com/rss
      http://tvblogs.nationalgeographic.com/feed/
      http://potd.pdnonline.com/feed/
      http://www.nationalgeographic.com.cn/index.php?m=content&c=feed
    )

    feed_urls.each do |url|
      FeedChannel.find_or_create_by url: url
    end
  end

  desc 'get feeds data'
  task fetch: :environment do
    FeedChannel.all.each do |channel|
      begin
        puts "Start fetching from #{channel.url}"
        feed = Feedjira::Feed.fetch_and_parse channel.url
        if channel.last_modified.blank? || feed.last_modified > channel.last_modified
          print "\tStart inserting articles"
          channel.update_attributes last_modified: feed.last_modified, title: feed.title
          feed.entries.each do |entry|
            unless channel.articles.exists?(url: entry.url)
              categories = entry.categories.map {|c| Category.find_or_create_by label: c }
              channel.articles.create title: entry.title, url: entry.url, pub_date: entry.published, author: entry.author, categories: categories
              print '.'
            end
          end
          print "\n"
        end
      rescue Feedjira::FetchFailure => e
        Rails.logger.warn e.message
      end
    end
  end

end