module Models
  module Extensions
    module Page
      module Parse

        extend ActiveSupport::Concern

        included do
          field :serialized_template, :type => Binary
          field :template_dependencies, :type => Array, :default => []
          field :snippet_dependencies, :type => Array, :default => []

          attr_reader :template_changed

          before_validation :serialize_template
          after_save :update_template_descendants

          validate :template_must_be_valid

          scope :pages, lambda { |domain| { :any_in => { :domains => [*domain] } } }
        end

        module InstanceMethods

          def template
            @template ||= Marshal.load(read_attribute(:serialized_template).to_s) rescue nil
          end

          protected

          def serialize_template
            if self.new_record? || self.raw_template_changed?
              @template_changed = true

              @parsing_errors = []

              begin
                self._parse_and_serialize_template
              rescue ::Liquid::SyntaxError => error
                puts "Liquid error"
                puts error.message
                puts error.backtrace
                @parsing_errors << I18n.t(:liquid_syntax, :fullpath => self.fullpath, :error => error.to_s,:scope => [:errors, :messages])
              rescue ::Locomotive::Liquid::PageNotFound => error
                @parsing_errors << I18n.t(:liquid_extend, :fullpath => self.fullpath,:scope => [:errors, :messages])
              end
            end
          end

          def _parse_and_serialize_template(context = {})
            self.parse(context)
            self._serialize_template
          end

          def _serialize_template
            self.serialized_template = BSON::Binary.new(Marshal.dump(@template))
          end

          def parse(context = {})
            self.disable_all_editable_elements
            
            default_context = { :site => self.site, :page => self, :templates => [], :snippets => [] }

            context = default_context.merge(context)

            @template = ::Liquid::Template.parse(self.raw_template, context)

            self.template_dependencies = context[:templates]
            self.snippet_dependencies = context[:snippets]
            
            @template.root.context.clear
          end

          def template_must_be_valid
            @parsing_errors.try(:each) { |msg| self.errors.add :template, msg }
          end

          def update_template_descendants
            return unless @template_changed == true

            # we admit at this point that the current template is up-to-date
            template_descendants = self.site.pages.any_in(:template_dependencies => [self.id]).to_a

            # group them by fullpath for better performance
            cached = template_descendants.inject({}) { |memo, page| memo[page.fullpath] = page; memo }

            self._update_direct_template_descendants(template_descendants, cached)

            # finally save them all
            template_descendants.map(&:save)
          end

          def _update_direct_template_descendants(template_descendants, cached)
            direct_descendants = template_descendants.select do |page|
              ((page.template_dependencies || []) - (self.template_dependencies || [])).size == 1
            end

            direct_descendants.each do |page|
              page.send(:_parse_and_serialize_template, { :cached_parent => self, :cached_pages => cached })

              page.send(:_update_direct_template_descendants, template_descendants, cached)
            end
          end

        end

      end
    end
  end
end