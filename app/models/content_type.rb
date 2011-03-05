class ContentType

  include Locomotive::Mongoid::Document

  ## fields ##
  field :name
  field :description
  field :slug
  field :order_by
  field :highlighted_field_name
  field :group_by_field_name
  field :api_enabled, :type => Boolean, :default => false
  field :api_accounts, :type => Array

  ## associations ##
  referenced_in :site
  embeds_many :contents, :class_name => 'ContentInstance' do
    def visible
      @target.find_all { |c| c.visible? }
    end
  end

  ## indexes ##
  index [[:site_id, Mongo::ASCENDING], [:slug, Mongo::ASCENDING]]

  ## callbacks ##
  before_validation :normalize_slug
  before_save :set_default_values
  after_destroy :remove_uploaded_files

  ## validations ##
  validates_presence_of :site, :name, :slug
  validates_uniqueness_of :slug, :scope => :site_id
  validates_size_of :content_custom_fields, :minimum => 1, :message => :array_too_short

  ## behaviours ##
  custom_fields_for :contents

  ## methods ##

  def groupable?
    self.group_by_field && group_by_field.category?
  end

  def list_or_group_contents
    if self.groupable?
      groups = self.contents.klass.send(:"group_by_#{self.group_by_field._alias}", :ordered_contents)

      # look for items with no category or unknown ones
      items_without_category = self.contents.find_all { |c| !self.group_by_field.category_ids.include?(c.send(self.group_by_field_name)) }
      if not items_without_category.empty?
        groups << { :name => nil, :items => items_without_category }
      else
        groups
      end
    else
      self.ordered_contents
    end
  end

  def ordered_contents(conditions = {})
    column = self.order_by.to_sym

    (if conditions.nil? || conditions.empty?
      self.contents
    else
      conditions_with_names = {}

      conditions.each do |key, value|
        # convert alias (key) to name
        field = self.content_custom_fields.detect { |f| f._alias == key }

        conditions_with_names[field._name.to_sym] = value
      end

      self.contents.where(conditions_with_names)
    end).sort { |a, b| (a.send(column) || 0) <=> (b.send(column) || 0) }
  end

  def sort_contents!(order)
    order.split(',').each_with_index do |id, position|
      self.contents.find(BSON::ObjectId(id))._position_in_list = position
    end
    self.save
  end

  def highlighted_field
    self.content_custom_fields.detect { |f| f._name == self.highlighted_field_name }
  end

  def group_by_field
    @group_by_field ||= self.content_custom_fields.detect { |f| f._name == self.group_by_field_name }
  end

  def to_liquid
    Locomotive::Liquid::Drops::Content.new(self)
  end

  protected

  def set_default_values
    self.order_by ||= 'created_at'
    self.highlighted_field_name ||= self.content_custom_fields.first._name
  end

  def normalize_slug
    self.slug = self.name.clone if self.slug.blank? && self.name.present?
    self.slug.slugify! if self.slug.present?
  end

  def remove_uploaded_files # callbacks are not called on each content so we do it manually
    self.contents.each do |content|
      self.content_custom_fields.each do |field|
        content.send(:"remove_#{field._name}!") if field.kind == 'file'
      end
    end
  end

end
