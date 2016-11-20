module DefaultFormat
  # extend ActiveSupport::Concern
  #
  # included do
  #   let(:default_format) { 'application/json' }
  #   prepend RequestHelpersCustomized
  # end
  #
  # module RequestHelpersCustomized
  #   lambda = lambda do |path, **kwarg|
  #     kwarg[:headers] = {accept: default_format}.merge(kwarg[:headers] || {})
  #     super(path, **kwarg)
  #   end
  #   %w(get post patch put delete).each do |method|
  #     define_method(method, lambda)
  #   end
  # end
end
