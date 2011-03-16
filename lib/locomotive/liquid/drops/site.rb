module Locomotive
  module Liquid
    module Drops
      class Site < Base

        liquid_attributes << :name << :meta_keywords << :meta_description

        def index
          @index ||= @source.pages.root.first
        end

        def pages
          @pages ||= @source.pages.to_a.collect(&:to_liquid)
        end
        
        def params
        	puts :controller.inspect
        	@context.registers[:controller].send(:get_params)
        end

      end
    end
  end
end
