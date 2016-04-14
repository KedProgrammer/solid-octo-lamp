module DashboardHelper
  def spent_between(range)
    Expense.between(range).sum(:amount)
  end

  def spent_by_month_and_type(range)
    Expense.spent_by_month_and_type(range)
  end

  def spent_by_day_and_type(range)
    Expense.spent_by_day_and_type(range)
  end

  def spent_by_category(range)
    Expense.spent_by_category(range).map do |key, value|
        { y: value, label: key ? Category.find(key).name : "Uncategorized" }
    end
  end

  def accumulated_by_day(range)
    Expense.accumulated_by_day(range)
  end

  def accumulated_range
    range = params[:accumulated_range]
    return past_month_range if range == "past_month"

    current_month_range
  end

  def past_accumulated_range
    range = params[:accumulated_range]
    return before_past_month_range if range == "past_month"

    past_month_range
  end

  def today_range
    now = Time.zone.now
    now.beginning_of_day..now.end_of_day
  end

  def yesterday_range
    y = 1.day.ago
    y.beginning_of_day..y.end_of_day
  end

  def current_month_range
    now = Time.zone.now
    now.beginning_of_month..now.end_of_day
  end

  def past_month_range
    m = 1.month.ago
    m.beginning_of_month..m.end_of_month
  end

  def last_six_months_range
    5.months.ago.beginning_of_month..Time.zone.now.end_of_day
  end

  def per_day_range
    range = params[:per_day_range]
    return past_month_range if range == "past_month"

    current_month_range
  end

  def format_month(data)
    data.map do |tx|
      tx[:date] = l(tx[:date], format: "%b '%y")
    end
    data.to_json.html_safe
  end

  def format_day(data)
    data.map do |tx|
      tx[:date] = l(tx[:date], format: "%d")
    end
    data.to_json.html_safe
  end
end
