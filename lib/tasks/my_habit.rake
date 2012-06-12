desc "MyHabit background processing"

task :process_event => :environment do
  require "my_habit"
  user = User.find(ENV["USER_ID"])
  Headless.ly do
    begin
      top_category = TopCategory.find(ENV["TOP_CATEGORY_ID"])
      event = MyHabit.new().event_from_url(ENV["URL"], top_category)
      Mailer.event_ready(user, event).deliver
    rescue Exception => e
      p e.inspect
      Mailer.event_ready(user, nil).deliver
    end
  end
end