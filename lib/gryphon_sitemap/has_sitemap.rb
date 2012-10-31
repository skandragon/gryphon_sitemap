module GryphonSitemap
  module HasSitemap
    def has_sitemap(options = {})
      @sitemap_size = options[:per_page] || 5000
      @sitemap_fields = options[:fields] || []

      extend ClassMethods
    end

    module ClassMethods
      def sitemap_page_count
        item_count = count
        pages = item_count / @sitemap_size
        pages += 1 if (item_count % @sitemap_size) != 0
        pages
      end

      def sitemap_page(page)
        fields = @sitemap_fields + [:id, :updated_at]

        query = order(:id).limit(@sitemap_size).select(fields).offset(page * @sitemap_size)
      end
    
      def sitemap_size
        @sitemap_size
      end
    
      def sitemap_fields
        @sitemap_fields
      end
    end
  end
end

ActiveRecord::Base.extend GryphonSitemap::HasSitemap
