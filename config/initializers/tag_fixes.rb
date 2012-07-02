module ActsAsTaggableOn
  class Tag 
    def safe_name
       # With non ASCII tags we have empty strings here and collisions on table aliases in joins
       # name.gsub(/[^a-zA-Z0-9]/, '')
       Russian.translit(name|| "").gsub(/[^a-zA-Z0-9]/, '')
    end

    class << self
      private
        def comparable_name(str)
          # ruby 1.9.x doesn't downcase non ASCII chars
          # RUBY_VERSION >= "1.9" ? str.downcase : str.mb_chars.downcase
          str.mb_chars.downcase
        end
    end
  end
end