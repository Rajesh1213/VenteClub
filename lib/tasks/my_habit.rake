desc "MyHabit background processing"

task :process_event => :environment do
  require "my_habit"
  user = User.find(ENV["USER_ID"])
  url = ENV["URL"]
  Headless.ly do
    $background_task = true
    begin
      top_category = TopCategory.find(ENV["TOP_CATEGORY_ID"])
      event = MyHabit.new().event_from_url(url, top_category)
      Mailer.event_ready(user, event).deliver
    rescue Exception => e
      Mailer.event_ready(user, nil, "Url: " + url + "<br/> Error message: " + e.inspect.to_s).deliver
    end
    $background_task = false
  end
end