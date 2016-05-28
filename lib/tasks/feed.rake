require 'readability'
require 'open-uri'

namespace :feed do
  desc 'update feed channels'
  task update_channels: :environment do
    image_channels = %w(
      http://www.nationalgeographic.com.cn/index.php?m=content&c=feed
    )
    video_channels = %w(
      https://www.youtube.com/feeds/videos.xml?channel_id=UC_x5XG1OV2P6uZZ5FSM9Ttw
    )

    image_channels.each do |url|
      FeedChannel.find_or_create_by url: url
    end
    video_channels.each do |url|
      FeedChannel.find_or_create_by url: url, media_type: 'video'
    end
  end

  desc 'get feeds data'
  task fetch: :environment do
    include ActionView::Helpers::SanitizeHelper

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
              article_attributes.merge! hero_media_attrs(entry, channel)
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
    content = entry.content.try :sanitize
    return entry.content if content.present? && strip_tags(content).length > 300
    readability(entry.url).try :content
  end

  def hero_media_attrs entry, channel
    hero_media = entry.image.present? ? entry.image : readability(entry.url).try(:images).try(:first)
    {hero_media: hero_media, hero_media_type: channel.media_type}
  end

  def readability url
    @readability_doc ||= {}
    @readability_doc[url] ||= Readability::Document.new(open(url).read, tags: %w[div p img a], attributes: %w[src href], remove_empty_nodes: false)
  rescue StandardError
    nil
  end
end