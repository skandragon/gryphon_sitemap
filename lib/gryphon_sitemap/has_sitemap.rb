module GryphonSitemap
  module HasSitemap
    attr_reader :sitemap_size
    attr_reader :sitemap_fields

    def has_sitemap(options = {})
      @sitemap_size = options[:per_page] || 5000
      @sitemap_fields = Array(options[:fields] || [])

      extend ClassMethods
    end

    module ClassMethods
      def sitemap_page_count
        item_count = count
        pages = item_count / sitemap_size
        pages += 1 if (item_count % sitemap_size) != 0
        pages
      end

      def sitemap_page(page)
        fields = [:id, :updated_at] + sitemap_fields

        query = order(:id).limit(sitemap_size).select(fields).offset(page * sitemap_size)
      end
    end
  end
end

ActiveRecord::Base.extend GryphonSitemap::HasSitemap
