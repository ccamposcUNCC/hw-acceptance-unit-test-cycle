Given(/^the following movies exist:$/) do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #expect(Movie.all.count).to eq 4
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |arg1, arg2|
  expect(Movie.find_by_title(arg1).director).to eq arg2
  #pending # Write code here that turns the phrase above into concrete actions
end