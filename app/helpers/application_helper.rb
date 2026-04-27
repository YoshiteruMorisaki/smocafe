module ApplicationHelper
  def pagination_series(collection, window: 2)
    total_pages = collection.total_pages
    current_page = collection.current_page
    pages = [ 1, total_pages ]

    ((current_page - window)..(current_page + window)).each do |page|
      pages << page if page.between?(1, total_pages)
    end

    pages = pages.uniq.sort

    pages.each_with_object([]) do |page, items|
      items << :gap if items.last.is_a?(Integer) && page - items.last > 1
      items << page
    end
  end

  def pagination_link_params(page)
    request.query_parameters.merge(page: page)
  end
end
