task :gp do
  require 'rubygems'
  require 'watir-webdriver'
  require 'headless'
  puts "________________________________________________________________________________________________________________"
  start = DateTime.now

  Headless.ly do
    browser = Watir::Browser.new :ff
    browser.goto "watir.com"
  end


  finish = DateTime.now
  puts "Started at: " + start.to_s + "  Finished at: " + finish.to_s + "  Total:" + (finish.to_f - start.to_f).to_i.to_s + " sec"
end
