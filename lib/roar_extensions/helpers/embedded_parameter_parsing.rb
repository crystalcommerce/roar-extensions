module RoarExtensions::Helpers
  module EmbeddedParameterParsing

    def self.included(base)
      base.class_eval do
        before_filter :parse_embedded_params_filter
      end
    end

    def parse_embedded_params_filter
      params[:embedded] = parse_embedded_params(params[:embedded])
    end

    def parse_embedded_params(embedded_str)
      parse_embedded_params_list((embedded_str || '').split(','))
    end

  private
    def parse_embedded_params_list(embedded)
      with_children, without_children = embedded.map {|embed| embed.split(':', 2) }.
                                                 each {|pair| pair[0] = pair[0].to_sym}.
                                                 partition {|pair| pair.length > 1}

      nested_embeds = with_children.inject({}) {|acc, (direct_embed, child)|
                                                  acc[direct_embed] ||= []
                                                  acc[direct_embed] << child
                                                  acc
                                               }.map do |(direct_embed, children)|
                                                  [direct_embed, parse_embedded_params_list(children)]
                                                end

      without_children.flatten!
      without_children << Hash[nested_embeds] unless nested_embeds.empty?
      without_children
    end
  end
end
