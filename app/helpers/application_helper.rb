module ApplicationHelper

  def page_title
    " - " + @page_title if @page_title
  end

end
