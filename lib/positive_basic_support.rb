require "positive_basic_support/version"

require "active_support"
require "active_support/core_ext"

require_relative "positive_basic_support/modules"
require_relative "positive_basic_support/modules/constants_as_class_methods"

require_relative "positive_basic_support/basic_object_ext"
require_relative "positive_basic_support/checker"
require_relative "positive_basic_support/checker/error_factory"

module PositiveBasicSupport

  extend ::ActiveSupport::Concern

  included do
    ::BasicObject.class_eval do
      include ::PositiveBasicSupport::BasicObjectExt
    end

    ::Module.class_eval do
      include ::PositiveBasicSupport::BasicObjectExt::ClassMethods
    end

    ::BasicObject.class_eval do
      include PositiveBasicSupport::Checker
    end
  end

end

include PositiveBasicSupport
