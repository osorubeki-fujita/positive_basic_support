module PositiveBasicSupport::BasicObjectExt

  extend ::ActiveSupport::Concern

  module ClassMethods

    # @!group 名前空間に関するメソッド

    # 上位の名前空間のリスト（すべて）
    # @return [::Array]
    def upper_namespaces( _has_upper_namespaces = nil )
      if _has_upper_namespaces or ( _has_upper_namespaces.nil? and has_upper_namespaces? )
        splited = self.name.split( "::" )[0..-2]
        ary = ::Array.new
        for i in 0..( splited.length - 1 )
          ary << eval( splited[ 0..i ].join( "::" ) )
        end
        ary.reverse
      else
        nil
      end
    end

    # 上位の名前空間が存在するか否かを判定するメソッド
    # @return [Boolean]
    def has_upper_namespaces?
      # upper_namespaces.length > 1
      /\:\:/ === name
    end

    # 上位の名前空間のリスト（すぐ上のみ）
    # @return [::Class (Const)]
    def upper_namespace
      _has_upper_namespaces = has_upper_namespaces?
      if _has_upper_namespaces
        upper_namespaces( _has_upper_namespaces ).first
      else
        nil
      end
    end

    # @!endgroup

  end

  alias :meaningful? :present?

# @!group クラスの判定 - 数値

  # 数値か否かを判定するメソッド
  # @return [Boolean]
  # @example
  #   2.number? => true
  #   -17.number? => true
  #   3.5.number? => true
  #   -1.618.number? => true
  #
  #   "abc".number? => false
  #   [1.5, 1.6, 1.7].number? => false
  def number?
    kind_of?( ::Numeric )
  end

  # 整数か否かを判定するメソッド
  # @return [Boolean]
  # @example
  #   13.integer? => true
  #   -19.integer? => true
  #
  #   3.141592.integer? => false
  #   -2.71828.integer? => false
  #
  #   "pqr".integer? => false
  #   [3, 4, 5].integer? => false
  def integer?
    kind_of?( ::Integer )
  end


  # 自然数か否かを判定するメソッド
  # @param include_zero [Boolean] 0を含めるか否か（default: false）
  # @return [Boolean]
  # @example
  #  7.natural_number? => true
  #  7.natural_number?( include_zero: false ) => true
  #  7.natural_number?( include_zero: true ) => true
  #
  #  0.natural_number? => false
  #  0.natural_number?( include_zero: false ) => false
  #  0.natural_number?( include_zero: true ) => true
  #
  #  -5.natural_number? => false
  #  -5.natural_number?( include_zero: false ) => false
  #  -5.natural_number?( include_zero: true ) => false
  #
  #  1.7320508.natural_number? => false
  #  -2.2360979.natural_number? => false
  #
  #  "あいうえお".natural_number? => false
  #  "かきくけこ".natural_number?( include_zero: false ) => false
  #  "さしすせそ".natural_number?( include_zero: true ) => false
  #
  #  [3, 1, 4, 1, 5].natural_number? => false
  #  ["a", "b", "c"].natural_number?( include_zero: false ) => false
  #  [2, 7, 1, 8, 2, 8].natural_number?( include_zero: true ) => false
  # @note 内部で {#natural_number_including_zero?} , {#natural_number_except_for_zero?} を利用している．
  def natural_number?( include_zero: false )
    include_zero.should_be( :boolean , variable_name: :include_zero )

    if include_zero
      natural_number_including_zero?
    else
      natural_number_except_for_zero?
    end
  end

  # 「自然数または0」か否かを判定するメソッド（0 に対しても true を返す）
  # @return [Boolean]
  # @example
  #   13.natural_number_including_zero? => true
  #
  #   0.natural_number_including_zero? => true
  #
  #   6.7.natural_number_including_zero? => false
  #   -2.236.natural_number_including_zero? => false
  #   -83.natural_number_including_zero? => false
  #
  #   "あいうえお".natural_number_or_zero? => false
  #   [1, 1, 2, 3, 5, 8].natural_number_or_zero? => false
  def natural_number_including_zero?
    integer? and self >= 0
  end
  alias :natural_number_or_zero? :natural_number_including_zero?

  # @!group クラスの判定 - 文字列

  # 文字列（String クラスのインスタンス）か否かを判定するメソッド
  # @return [Boolean]
  def string?( include_subclasses: false )
    class_decision( ::String , include_subclasses )
  end

  # @!group クラスの判定 - シンボル

  # Symbol クラスのインスタンスか否かを判定するメソッド
  # @return [Boolean]
  def symbol?
    instance_of?( ::Symbol )
  end

  # @!group クラスの判定 - 文字列・シンボル

  # {String} クラスまたは {Symbol} クラスのインスタンスか否かを判定するメソッド
  # @return [Boolean]
  def string_or_symbol?( include_subclasses: false )
    string?( include_subclasses: include_subclasses ) or symbol?
  end

  # @!group クラスの判定 - 真偽値

  # 真偽値か否かを判定するメソッド
  # @return [Boolean] self が真偽値（true または false）の場合に true，それ以外の場合に false を返す．
  # @example
  #   true.boolean? => true
  #   false.boolean? => true
  #   nil.boolean? => false
  #
  #   2.boolean? => false
  #   "すべてのクレタ島人は嘘つきである。".boolean? => false
  def boolean?
    instance_of?( ::TrueClass ) or instance_of?( ::FalseClass )
  end

  # 「真偽値または nil 」か否かを判定するメソッド
  # @return [Boolean] self が真偽値（true または false）または nil の場合に true ，それ以外の場合に false を返す．
  # @example
  #   true.boolean_or_nil? => true
  #   false.boolean_or_nil? => true
  #   nil.boolean_or_nil? => true
  #
  #   3.boolean_or_nil? => false
  #   "王様は裸だ！".boolean_or_nil? => false
  def boolean_or_nil?
    boolean? or nil?
  end

  # @!endgroup

  private

  def class_decision( class_name , include_subclasses )
    include_subclasses.should_be( :boolean , variable_name: :include_subclasses , variable_number: 2 )
    if include_subclasses
      kind_of?( class_name )
    else
      instance_of?( class_name )
    end
  end

  # 自然数か否かを判定するメソッド（0 に対しては true を返さない）
  # @return [Boolean]
  # @note このメソッドは，{Object#error_message_of_class_sub_check_some_variables} と {Object#natural_number?} で使用するためのもの．
  #   通常は{Object#natural_number?} を利用すること．
  # @example
  #   2.natural_number_except_for_zero? => true
  #
  #   0.natural_number_except_for_zero? => false
  #
  #   4.8.natural_number_except_for_zero? => false
  #   -1.732.natural_number_except_for_zero? => false
  #   -71.natural_number_except_for_zero? => false
  #
  #   "あいうえお".natural_number_except_for_zero? => false
  #   [10, 20, 30].natural_number_except_for_zero? => false
  def natural_number_except_for_zero?
    integer? and self > 0
  end

end
