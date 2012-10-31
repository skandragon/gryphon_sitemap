xml.instruct!
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  #
  # Generic template to render a group of ActiveRecord items.
  #
  if @items.count > 0
    for item in @items
      xml.url do
        xml.loc polymorphic_url(item)
        xml.lastmod item.updated_at.to_s(:w3c)
      end
    end
  else
    xml.url do
      xml.loc root_url
    end
  end
end
