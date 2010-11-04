module HasFbOpengraph

  def fb_opengraph_meta_tag(key, raw_value)
    %(<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:#{key.to_s}" content="#{raw_value}" />)
  end

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def has_fb_opengraph(options = {})
      cattr_accessor :fb_opengraph
      self.fb_opengraph = options
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    def fb_opengraph_meta_tags(options = {})
      opengraph_fields = self.fb_opengraph.merge(options)
      output = ''
      opengraph_fields.each do |key, value|
        raw_value = (value.is_a?(Symbol) ? self.send(value) : value)
        output<< fb_opengraph_meta_tag(key, raw_value)
      end
      return output
    end
  end
end

ActiveRecord::Base.send :include, HasFbOpengraph
