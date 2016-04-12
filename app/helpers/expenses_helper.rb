module ExpensesHelper
  def link_to_type(type)
    path = expenses_path(request.query_parameters.merge(type: type))
    path = expenses_path(request.query_parameters.except(:type)) if is_type_active(type)
    link_to type_as_str(type), path, class: "list-group-item #{'active' if is_type_active(type) }"
  end

  def link_to_category(category)
    path = expenses_path(request.query_parameters.merge(category: category.id))
    path = expenses_path(request.query_parameters.except(:category)) if is_category_active(category)
    link_to category.name, path, class: "list-group-item #{'active' if is_category_active(category) }"
  end

  def type_as_str(type, *args)
    options = args.extract_options!

    type = type.to_sym if type.respond_to?(:to_sym)
    type && (options[:pluralize] ? pluralize(2, Expense.types[type]).split(" ", 2)[1] : type).capitalize
  end

  private
    def is_type_active(type)
      params[:type] == type
    end

    def is_category_active(category)
      params[:category] == category.id.to_s
    end
end
