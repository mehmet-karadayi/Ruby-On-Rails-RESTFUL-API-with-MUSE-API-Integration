task retrieve: :environment do
  
  puts 'HERE'
  
  require 'open-uri'
  require 'json'
  
  page = 1
  # This loop sets the range of pages we will request [1,5]
  while (page <= 10)
    
    url = "https://www.themuse.com/api/public/jobs?api_key=d725130dbf7f03a077f15047a49a435bcb4ab70186ec2983520250278fed20ee&page=#{page}&descending=true"
    response = URI.open(url).read
    
    json = JSON.parse(response)

    # Each page has 20 results.  
    for  i in 0..19
      job_title = json["results"][i]["name"]
      
      comp = json["results"][i]["company"]
      company = comp["short_name"]
      
      loc = json["results"][i]["locations"]
      # checks to see wheter or not the location information is given.  Failure to check this gives a NIL error
      if (loc[0]) == nil
        location = "Unkown"
      else 
        location = loc[0]["name"]
        
      end

      summary = json["results"][i]["contents"].gsub('<p>', ' ').gsub('<br>', ' ').gsub('<ul>', ' ').gsub('<li>', ' ').gsub('<strong>', ' ').gsub('<b>', '').gsub('</br>', '').gsub('</strong>', '')
      
      uRl = json["results"][i]["refs"]
      url = uRl["landing_page"]
    
      # We check to see if there are repeating listings
      if Listing.where(job_title:job_title, company:company, location:location,summary:summary, url:url).count <= 0
        Listing.create(
          job_title: job_title,
          company: company,
          location: location,
          summary: summary,
          url: url)

        puts 'Added: ' + (job_title ? job_title : '')
      else
        puts 'Skipped: ' + (job_title ? job_title : '')
      end

    end

    page += 1
  end
end