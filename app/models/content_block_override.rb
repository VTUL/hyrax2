module ContentBlockOverride

  def self.prepended(base)
    base.singleton_class.prepend ClassMethods
  end
    
  # Class methods
  module ClassMethods
    def default_terms_text
      ERB.new(
        IO.read(
          Rails.root.join('app', 'views', 'hyrax', 'content_blocks', 'templates', 'terms.html.erb')
        )
      ).result
    end
  end
end
