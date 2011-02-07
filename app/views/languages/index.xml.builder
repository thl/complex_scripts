xml.instruct!
xml.languages(:type => 'array') do
  @languages.each { |language| xml << render(:partial => 'show', :locals => {:language => language}) }
end