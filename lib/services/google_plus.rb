class GooglePlusService < Service
  def self.handles?(uri)
    uri.host =~ /plus.google.com$/
  end
  
  def self.shortname
    :google_plus
  end
  
  def self.longname
    "Google+"
  end
  
  def display_name
    "Google Plus ID: #{account}"
  end

  def account
    /^(\/u\/0)?\/(?<account>\d+)(\/posts)?/ =~ @uri.path
    account
  end
  
  def service_url_example
    "https://plus.google.com/110031535020051778989/posts"
  end
  
  def service_url_canonical
    "https://plus.google.com/#{account}"
  end
  
  private
  
  def fetch_details
    {
      :account => account,
    }
  end
end

Service.register(:google_plus, GooglePlusService)
