module ApplicationHelper
  def nav_icon_class(path)
    if current_page?(path)
      'bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium'
    else
      'text-gray-300 hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium'
    end
  end
end
