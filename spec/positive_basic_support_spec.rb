require 'spec_helper'
require 'deplo'

spec_filename = ::File.expand_path( ::File.dirname( __FILE__ ) )
version = "0.1.0"

describe PositiveBasicSupport do
  it "has a version number \'#{ version }\'" do
    expect( ::PositiveBasicSupport::VERSION ).to eq( version )
    expect( ::Deplo.version_check( ::PositiveBasicSupport::VERSION , spec_filename ) ).to eq( true )
  end

  it "has the method \'number?\'" do
    expect( 2.number? ).to eq( true )
    expect( -17.number? ).to eq( true )
    expect( 3.5.number? ).to eq( true )
    expect( -1.618.number? ).to eq( true )
    expect( "abc".number? ).to eq( false )
    expect( [1.5, 1.6, 1.7].number? ).to eq( false )
  end

  it "has the method \'integer?\'" do
    expect( 13.integer? ).to eq( true )
    expect( -19.integer? ).to eq( true )
    expect( 3.141592.integer? ).to eq( false )
    expect( -2.71828.integer? ).to eq( false )
    expect( "pqr".integer? ).to eq( false )
    expect( [3, 4, 5].integer? ).to eq( false )
  end

  it "has the method \'natural_number?\'" do
    expect( 7.natural_number? ).to eq( true )
    expect( 7.natural_number?( include_zero: false ) ).to eq( true )
    expect( 7.natural_number?( include_zero: true ) ).to eq( true )
    expect( 0.natural_number? ).to eq( false )
    expect( 0.natural_number?( include_zero: false ) ).to eq( false )
    expect( 0.natural_number?( include_zero: true ) ).to eq( true )
    expect( -5.natural_number? ).to eq( false )
    expect( -5.natural_number?( include_zero: false ) ).to eq( false )
    expect( -5.natural_number?( include_zero: true ) ).to eq( false )
    expect( 1.7320508.natural_number? ).to eq( false )
    expect( -2.2360979.natural_number? ).to eq( false )
    expect( "あいうえお".natural_number? ).to eq( false )
    expect( "かきくけこ".natural_number?( include_zero: false ) ).to eq( false )
    expect( "さしすせそ".natural_number?( include_zero: true ) ).to eq( false )
    expect( [3, 1, 4, 1, 5].natural_number? ).to eq( false )
    expect( ["a", "b", "c"].natural_number?( include_zero: false ) ).to eq( false )
    expect( [2, 7, 1, 8, 2, 8].natural_number?( include_zero: true ) ).to eq( false )
  end

  it "has the method \'natural_number_including_zero?\'" do
    expect( 13.natural_number_including_zero? ).to eq( true )
    expect( 0.natural_number_including_zero? ).to eq( true )
    expect( 6.7.natural_number_including_zero? ).to eq( false )
    expect( -2.236.natural_number_including_zero? ).to eq( false )
    expect( -83.natural_number_including_zero? ).to eq( false )
    expect( "あいうえお".natural_number_including_zero? ).to eq( false )
    expect( [1, 1, 2, 3, 5, 8].natural_number_including_zero? ).to eq( false )
  end

  it "has the method \'natural_number_or_zero?\'" do
    expect( 13.natural_number_or_zero? ).to eq( true )
    expect( 0.natural_number_or_zero? ).to eq( true )
    expect( 6.7.natural_number_or_zero? ).to eq( false )
    expect( -2.236.natural_number_or_zero? ).to eq( false )
    expect( -83.natural_number_or_zero? ).to eq( false )
    expect( "あいうえお".natural_number_or_zero? ).to eq( false )
    expect( [1, 1, 2, 3, 5, 8].natural_number_or_zero? ).to eq( false )
  end

  it "has the private method \'natural_number_except_for_zero?\'" do
    expect( 2.send( :natural_number_except_for_zero? ) ).to eq( true )
    expect( 0.send( :natural_number_except_for_zero? ) ).to eq( false )
    expect( 4.8.send( :natural_number_except_for_zero? ) ).to eq( false )
    expect( -1.732.send( :natural_number_except_for_zero? ) ).to eq( false )
    expect( -71.send( :natural_number_except_for_zero? ) ).to eq( false )
    expect( "あいうえお".send( :natural_number_except_for_zero? ) ).to eq( false )
    expect( [10, 20, 30].send( :natural_number_except_for_zero? ) ).to eq( false )
  end

  it "has the method \'string?\'" do
    expect( true.boolean? ).to eq( true )
    expect( false.boolean? ).to eq( true )
    expect( nil.boolean? ).to eq( false )
    expect( 2.boolean? ).to eq( false )
    expect( "すべてのクレタ島人は嘘つきである。".boolean? ).to eq( false )
  end

  it "has the method \'boolean_or_nil?\'" do
    expect( true.boolean_or_nil? ).to eq( true )
    expect( false.boolean_or_nil? ).to eq( true )
    expect( nil.boolean_or_nil? ).to eq( true )
    expect( 3.boolean_or_nil? ).to eq( false )
    expect( "王様は裸だ！".boolean_or_nil? ).to eq( false )
  end

end

require_relative 'positive_basic_support_spec/basic_object_ext.rb'
