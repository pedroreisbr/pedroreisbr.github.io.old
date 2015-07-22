require 'pry'

module Jekyll
  module Paginate_pk
    class Pagination_pk < Generator
      # This generator is safe from arbitrary code execution.
      safe true

      # This generator should be passive with regard to its execution
      priority :lowest

      # Generate paginated pages if necessary.
      #
      # site - The Site.
      #
      # Returns nothing.
      def generate(site)
        for collection in site.collection_names
        # collection="posts"
          if site.config["collections"]["#{collection}"]["paginate"] == true
            site.config['paginate_path'] = "/#{collection}/:num"  
            # puts site.config['paginate_path']
            if Pager_pk.pagination_enabled?(site)
              if template = self.class.template_page(site, collection)
                 paginate(site, template, collection)
              else
                Jekyll.logger.warn "Pagination:", "Pagination is enabled, but I couldn't find " +
                "an index.html page to use as the pagination template. Skipping pagination."
              end
            end
            site.config['paginate_path'] = '/index/:num'  
          end
        end
      end

      # Paginates the blog's posts. Renders the index.html file into paginated
      # directories, e.g.: page2/index.html, page3/index.html, etc and adds more
      # site-wide data.
      #
      # site - The Site.
      # page - The index.html Page that requires pagination.
      #
      # {"paginator" => { "page" => <Number>,
      #                   "per_page" => <Number>,
      #                   "posts" => [<Post>],
      #                   "total_posts" => <Number>,
      #                   "total_pages" => <Number>,
      #                   "previous_page" => <Number>,
      #                   "next_page" => <Number> }}
      def paginate(site, page, collection)
        all_posts = site.collections[collection].docs.reject{|item| item.basename=="0001-01-01-index.md"}
        pages = Pager_pk.calculate_pages(all_posts, site.config['paginate'].to_i)
        (1..pages).each do |num_page|
          pager = Pager_pk.new(site, num_page, all_posts, pages)
          if num_page > 1
            newpage = Page.new(site, site.source, "_#{collection}/","0001-01-01-index.md")
            newpage.content = site.collections["#{collection}"].docs.first.content
            newpage.data = site.collections["#{collection}"].docs.first.data
            pager = Pager_pk.pager_hash(site, num_page, all_posts, pages,collection)
            newpage.data = newpage.data.merge(pager)
            newpage.dir = "/#{collection}/#{num_page}/"
            newpage.basename = "index"
            site.pages << newpage
          else
            newpage = Page.new(site, site.source, "_#{collection}/","0001-01-01-index.md")
            newpage.content = site.collections["#{collection}"].docs.first.content
            newpage.data = site.collections["#{collection}"].docs.first.data
            pager = Pager_pk.pager_hash(site, num_page, all_posts, pages,collection)
            newpage.data = newpage.data.merge(pager)
            newpage.dir = "/#{collection}/"
            newpage.basename = "index"
            site.pages << newpage
          end
        end
      end

      # Static: Fetch the URL of the template page. Used to determine the
      #         path to the first pager in the series.
      #
      # site - the Jekyll::Site object
      #
      # Returns the url of the template page
      def self.first_page_url(site)
        if page = Pagination_pk.template_page(site)
          page.url
        else
          nil
        end
      end

      # Public: Find the Jekyll::Page which will act as the pager template
      #
      # site - the Jekyll::Site object
      #
      # Returns the Jekyll::Page which will act as the pager template
      def self.template_page(site, collection='posts')
        for page in site.collections["#{collection}"].docs
          if Pager_pk.pagination_candidate?(site.config, page, collection)
            return page
          end
        end      
      end
    end
  end
end