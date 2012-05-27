module ApplicationHelper

  def page_title
    " - " + @page_title if @page_title
  end

  def event_date(datetime)
    (l datetime).upcase.gsub("AT", "at")
  end

end
