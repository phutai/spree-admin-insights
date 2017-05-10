module Spree
  class ReportGenerationService

    REPORTS = {
      finance_analysis:           [
        :payment_method_transactions, :payment_method_transactions_conversion_rate,
        :shipping_cost, :sales_tax, :sales_performance
      ],
      product_analysis:           [
        :best_selling_products, :cart_additions, :cart_removals, :cart_updations,
        :product_views, :product_views_to_cart_additions,
        :product_views_to_purchases, :unique_purchases,
        :returned_products
      ],
      promotion_analysis:         [:promotional_cost],
      trending_search_analysis:   [:trending_search],
      user_analysis:              [:user_pool, :users_not_converted, :users_who_recently_purchased],
    }

    def self.generate_report(report_name, options)
      klass = Spree.const_get((report_name.to_s + '_report').classify)
      resource = klass.new(options)
      dataset = resource.generate
    end

    def self.download(report, options = {})
      headers = report.headers
      stats = report.observations
      ::CSV.generate(options) do |csv|
        csv << headers.map { |head| head[:name] }
        stats.each do |record|
          csv << headers.map { |head| record.public_send(head[:value]) }
        end
      end
    end

    def self.report_exists?(type, name)
      REPORTS.key?(type) && REPORTS[type].include?(name)
    end

    def self.reports_for_type(type)
      REPORTS[type]
    end

    def self.default_report_type
      REPORTS.keys.first
    end

    def self.register_report_category(category)
      REPORTS[category] = []
    end

    def self.register_report(category, report_name)
      REPORTS[category] << report_name
    end

  end
end
