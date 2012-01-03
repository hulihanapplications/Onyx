module BrowseHelper
 def friendly_date(date)
  if date > Time.now.beginning_of_day
   return "Added <b>Today</b> at "+ date.strftime("%I:%M %p")
  end 

  if (date < Time.now.beginning_of_day) and (date > Time.now.yesterday.beginning_of_day)
   return "Added <b>Yesterday</b> at "+ date.strftime("%I:%M %p")
  end 

  if (date < Time.now.yesterday.beginning_of_day) and (date > Time.now.beginning_of_week)
   return  "Added <b>" + date.strftime("%A") + "</b> at " +  date.strftime("%I:%M %p")
  end 
 
   #anything past a week...  
   return "Added <b>" + date.strftime("%b %d") + "</b> at " + date.strftime("%I:%M %p")
 end

end
