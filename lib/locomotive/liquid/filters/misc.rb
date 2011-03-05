module Locomotive
  module Liquid
    module Filters
      module Misc

        def underscore(input)
          input.to_s.gsub(' ', '_').gsub('/', '_').underscore
        end

        def dasherize(input)
          input.to_s.gsub(' ', '-').gsub('/', '-').dasherize
        end

        def concat(input, *args)
          result = input.to_s
          args.flatten.each { |a| result << a.to_s }
          result
        end

        def modulo(word, index, modulo)
          (index.to_i + 1) % modulo == 0 ? word : ''
        end
        
        def get(conditions)
        	@content_type.contents.klass.send('where', conditions)
        end
        
        def get2(conditions)
        	@content_type.contents.klass.where(conditions)
        end
        
        def get3(conditions)
        	@content_type.contents.find(:all, :conditions => conditions)
        end

      end

      ::Liquid::Template.register_filter(Misc)

    end
  end
end
