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
            puts '\n\n$ Iniciando geração do Site através Pagination PK'
            puts '$ Chama função Pager_pk.pagination_enabled()'
            if Pager_pk.pagination_enabled?(site)
              puts '$ Retornou verdadeiro'
              puts "$ Chama função Pagination_pk.template_page()"
              if template = self.class.template_page(site, collection)
                puts "\n\n$%%%%%%%%%%%%%%%%%%%%%% template: \n#{template}"
                puts "\n\n$ --------------------PARTE 2 -------------------------------"
                puts "\n$ Chama a função paginate()"
                paginate(site, template, collection)
                puts "\n\n$ --------------------_FIM -------------------------------"
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
        puts "$$ Gera a lista de posts"
        all_posts = site.collections[collection].docs.reject{|item| item.basename=="0001-01-01-index.md"}
        puts "$$ all_posts: #{all_posts}"
        puts "$$ Chama função Pager_pk.calculate_pages"
        pages = Pager_pk.calculate_pages(all_posts, site.config['paginate'].to_i)
        puts "$$$ Retorna total de paginas: pages = total_posts / qtd_por_page = (#{all_posts.size.to_f} / #{site.config['paginate'].to_i}) = #{pages}"
        puts "$$ Loop de 1..#{pages}(pages)"
        (1..pages).each do |num_page|
          puts "$$ %%%%%%%%%%%%%%%%%%%%%%%%%%% Página #{num_page} (num_page) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
          puts "$$ Chama a função Pager_pk.new (paper)"
          pager = Pager_pk.new(site, num_page, all_posts, pages)
          puts "VOLTOU"
          if num_page > 1
            # puts "$$ Se num_page(#{num_page}) for maior que 1"
            # puts "$$ Chama a função Page.new da biblioteca do jekyll (newpage):"
            # puts "--------- site: #{site}"
            # puts "--------- site.source: #{site.source}"
            # puts "--------- page.dir: _#{collection}/"
            # puts "--------- page.name: #{page.basename}"
            # newpage = Page.new(site, site.source, "_#{collection}/", page.basename)
            # # binding.pry if num_page==2
            # newpage.pager = pager
            # # binding.pry if num_page==2
            # newpage.dir = "/#{collection}/#{num_page}/"
            # newpage.ext = ".html"
            # # binding.pry if num_page==2
            # # newpage.name = "index"
            # newpage.basename = "index"
            # # newpage.permalink = "/caixadagua/#{num_page}/"
            # puts "$$ Adiciona a nova página à site.pages"
            # site.pages << newpage
            # # binding.pry if num_page==3
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
            # newpage.pager = pager
            newpage.dir = "/#{collection}/"
            newpage.basename = "index"
            # newpage.ext = ".html"
            site.pages << newpage
            # binding.pry
            # # page.pager = pager
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
        puts "$$ Seleciona cada uma das páginas"
        # puts "$$ config: #{site.config}"
        for page in site.collections["#{collection}"].docs
        # site.pages.select do |page|
          # puts "$$ page (conteúdo da página): #{page}"
          puts "\n\n$$ Chama função Pager_pk.pagination_candidate"
          puts "¨¨¨¨¨¨¨¨¨¨¨ Página #{page.path} (#{page.basename})¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨"
          puts "EXISTE 5555555555555555555555555555555555555555555555555555555 #{Pager_pk.pagination_candidate?(site.config, page, collection)}"
          if Pager_pk.pagination_candidate?(site.config, page, collection)
            return page
          end
        end#.sort do |one, two|
        #   two.path.size <=> one.path.size
        # end.first
      end

    end
  end
end