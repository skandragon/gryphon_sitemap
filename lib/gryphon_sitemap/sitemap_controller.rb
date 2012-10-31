module GryphonSitemap
  module SitemapController
    def index
      @indexes = indexed_pages
    end

    def show
      item_name = params[:id]
      found_index = indexed_pages[item_name.to_sym]
      page_not_found if found_index.blank?

      if respond_to?item_name
        send(item_name)
      else
        @items = item_name.to_s.classify.constantize.sitemap_page(params[:page].to_i)
        render :generic
      end
    end

    private

    def fixup_missing_page_counts
      indexed_pages.each do |item_name, options|
        next unless options[:dynamic].present?

        options[:pages] = item_name.to_s.classify.constantize.sitemap_page_count
      end
    end
  end
end