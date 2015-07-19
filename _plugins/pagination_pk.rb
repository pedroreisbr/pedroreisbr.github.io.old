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
        puts '\n\n$ Iniciando geração do Site através Pagination PK'
        puts '$ Chama função Pager_pk.pagination_enabled()'
        if Pager_pk.pagination_enabled?(site)
          puts '$ Retornou verdadeiro'
          puts "$ Chama função Pagination_pk.template_page()"
          if template = self.class.template_page(site)
            puts "\n\n$ template: #{template}"
            puts "\n\n$ --------------------PARTE 2 -------------------------------"
            puts "\n$ Chama a função paginate()"
            paginate(site, template)
            puts "\n\n$ --------------------_FIM -------------------------------"
          else
            Jekyll.logger.warn "Pagination:", "Pagination is enabled, but I couldn't find " +
            "an index.html page to use as the pagination template. Skipping pagination."
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
      def paginate(site, page)
        puts "$$ Gera a lista de posts"
        all_posts = site.site_payload['site']['posts'].reject { |post| post['hidden'] }
        puts "$$ all_posts: #{all_posts}"
        puts "$$ Chama função Pager_pk.calculate_pages"
        pages = Pager_pk.calculate_pages(all_posts, site.config['paginate'].to_i)
        puts "$$$ Retorna total de paginas: pages = total_posts / qtd_por_page = (#{all_posts.size.to_f} / #{site.config['paginate'].to_i}) = #{pages}"
        puts "$$ Loop de 1..#{pages}(pages)"
        (1..pages).each do |num_page|
          puts "$$ %%%%%%%%%%%%%%%%%%%%%%%%%%% Página #{num_page} (num_page) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
          puts "$$ Chama a função Pager_pk.new (paper)"
          pager = Pager_pk.new(site, num_page, all_posts, pages)
          if num_page > 1
            puts "$$ Se num_page(#{num_page}) for maior que 1"
            puts "$$ Chama a função Page.new da biblioteca do jekyll (newpage):"
            puts "--------- site: #{site}"
            puts "--------- site.source: #{site.source}"
            puts "--------- page.dir: #{page.dir}"
            puts "--------- page.name: #{page.name}"
            newpage = Page.new(site, site.source, page.dir, page.name)
            newpage.pager = pager
            newpage.dir = Pager_pk.paginate_path(site, num_page)
            puts "$$ Adiciona a nova página à site.pages"
            site.pages << newpage
          else
            page.pager = pager
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
      def self.template_page(site)
        puts "$$ Seleciona cada uma das páginas"
        # puts "$$ config: #{site.config}"
        site.pages.select do |page|
          # puts "$$ page (conteúdo da página): #{page}"
          puts "\n\n$$ Chama função Pager_pk.pagination_candidate"
          Pager_pk.pagination_candidate?(site.config, page)
        end.sort do |one, two|
          two.path.size <=> one.path.size
        end.first
      end

    end
  end
end