module DirectoryIndexPlugin
  class DirectoryIndexGenerator < Jekyll::Generator
    safe true

    def generate(site)
      dirs = site.config['directory_listing_dirs'] || []
      dirs.each do |dir|
        site.pages << DirectoryIndexPage.new(site, site.source, dir)
      end
    end
  end

  class DirectoryIndexPage < Jekyll::Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_includes'), 'directory_listing.html')
      self.data['layout'] = nil
      self.content = "{% include directory_listing.html directory='#{dir}' %}"
    end
  end
end