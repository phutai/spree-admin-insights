require 'spec_helper'

describe Spree::UsersWhoRecentlyPurchasedReport do

  let(:start_date) { (Date.today - 10.days).to_s }
  let(:end_date) { Date.today.to_s }
  let(:search_params) { { search: { start_date: start_date, end_date: end_date, email_cont: 'ruby' } } }
  let(:report) { Spree::UsersWhoRecentlyPurchasedReport.new(search_params) }

  describe '#initialize' do
    it { expect(report.instance_variable_get(:@start_date)).to be_an_instance_of(Date) }
    it { expect(report.instance_variable_get(:@end_date)).to be_an_instance_of(Date) }
    it { expect(report.instance_variable_get(:@email_cont)).to eq('%ruby%') }
    it { expect(report.instance_variable_get(:@sortable_type)).to eq(:asc) }
    it { expect(report.sortable_attribute).to eq(:user_email) }
  end

  describe '#generate' do
    it { expect(report.generate).to be_an_instance_of(Sequel::Mysql2::Dataset)}
  end

  describe '#select_columns' do
    before { @dataset = report.generate }
    it { expect(report.select_columns(@dataset)).to be_an_instance_of(Sequel::Mysql2::Dataset) }
  end

end
