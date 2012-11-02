require 'open-uri'
require "find_perl_modules/version"

module FindPerlModules

  class FindModules
    def initialize
      @rss_url = 'http://search.cpan.org/uploads.rdf'
      @new_modules = []
      @new_module_version = []
    end

    def parse_rss_data(rss)
      titles = rss.entries.map do |e|
        e.title
      end

      split_titles = titles.map do |t|
        t.split /-/
      end

      modules = []
      split_titles.each do |st|
        ver = st.pop
        mod = st.join "::"
        unless mod.empty?
          @new_modules << {full: "#{mod}-#{ver}", module: mod, version: ver}
        end
      end
    end

    def modules
      if @new_modules.empty?
          rss = SimpleRSS.parse open(@rss_url)
          parse_rss_data(rss)
      end
      @new_modules
    end

    def find_updated_modules
      modules.each do |m|
        cm = CheckedModule.where(:name => m[:module]).first
        unless cm.blank?
          sm = SeenModule.where('name = ? AND version = ?', m[:module], m[:version]).first
          if (sm.nil?)
            @new_module_version << m
            SeenModule.new(:name => m[:module], :version => m[:version]).save
          end
        end
      end
      @new_module_version
    end

    def send_email
      unless @new_module_version.empty?
        PerlRssNotifier.tell_of_update(@new_module_version).deliver
      end
    end

    def run
      find_updated_modules
      send_email
    end
  end
end
