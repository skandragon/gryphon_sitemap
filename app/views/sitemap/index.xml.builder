xml.instruct!
xml.sitemapindex :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  @indexes.each do |index_name, options|
    options[:pages].times do |page_number|
      xml.sitemap do
        xml.loc sitemap_url(index_name, page: page_number, format: :xml)
      end
    end
  end
end
