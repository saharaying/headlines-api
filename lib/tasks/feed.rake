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
    FeedChannel.enabled.each do |channel|
      begin
        puts "Start fetching from #{channel.url}"
        feed = Feedjira::Feed.fetch_and_parse channel.url
        if channel.last_modified.blank? || feed.last_modified > channel.last_modified
          print "\tStart inserting articles"
          feed.entries.each do |entry|
            unless channel.articles.exists?(url: entry.url)
              categories = entry.categories.map { |c| Category.find_or_create_by label: c }
              article_attributes = {
                  title: entry.title, url: entry.url, pub_date: entry.published, author: entry.author,
                  categories: categories
              }
              article_attributes[:content] = article_content(entry)
              article_attributes[:hero_image] = hero_image(entry)
              channel.articles.create article_attributes
              print '.'
            end
          end
          channel.update_attributes last_modified: feed.last_modified, title: feed.title
          print "\n"
        end
      rescue Feedjira::FetchFailure => e
        Rails.logger.warn e.message
      end
    end
  end

  task fetch_all: [:update_channels, :fetch]

  def article_content entry
    return entry.content if entry.content.present?
    return entry.summary if entry.summary.present?
    spidergo_doc(entry.url).try :article
  end

  def hero_image entry
    return entry.image if entry.image.present?
    spidergo_doc(entry.url).try :hero_image
  end

  def spidergo_doc url
    @spidergo_doc ||= {}
    @spidergo_doc[url] ||= Spidergo.document(url)
  rescue StandardError
    nil
  end
end