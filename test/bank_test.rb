require 'test_helper'

class BankTest < Minitest::Test
  include FlutterWaveTestHelper

  attr_reader :client, :gtb_name, :response_data, :url

  def setup
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    @client = Flutterwave::Client.new(merchant_key, api_key)
    @gtb_code = '058'
    @gtb_name = 'GTBank Plc'
  end

  def sample_data
    {
      'data' => {
        @gtb_code => gtb_name,
        Faker::Number.number(3) => Faker::Company.name,
        Faker::Number.number(3) => Faker::Company.name,
        Faker::Number.number(3) => Faker::Company.name
      },
      'status' => 'success'
    }
  end

  def test_list
    stub_values
    response = client.bank.list

    assert response.is_a? Array
    assert response.length.eql? 4
    assert response.all? {  |item| item.is_a? Flutterwave::Bank }
  end

  def test_find_by_code
    stub_values

    gtb_instance = Flutterwave::Bank.new(@gtb_code, gtb_name)
    response = client.bank.find_by_code(@gtb_code)

    assert_equal gtb_instance.code, response.code
    assert_equal gtb_instance.name, response.name
  end

  def test_find_by_name
    stub_values
    gtb_instance = Flutterwave::Bank.new(@gtb_code, gtb_name)
    response = client.bank.find_by_name(gtb_name)

    assert_equal gtb_instance.code, response.code
    assert_equal gtb_instance.name, response.name
  end

  def stub_values
    @response_data = sample_data
    @url = Flutterwave::Utils::Constants::BANK[:list_url]

    stub_flutterwave
  end
end
