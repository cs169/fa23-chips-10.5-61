# In your step definitions file, e.g., representative_steps.rb

Given('a representative information containing officials and offices') do
  # Implement logic to set up representative information with officials and offices
  
  # This might involve creating mock data or using test doubles for `rep_info`
end

When('the method civic_api_to_representative_params is called with the representative information') do
  # Call the `civic_api_to_representative_params` method with the prepared representative information
  # Capture the result for later assertions
  @created_reps = Representative.civic_api_to_representative_params(@prepared_rep_info)
end

Then('it should create Representative records based on the information') do
  expect(@created_reps).not_to be_empty
  expect(@created_reps.all? { |rep| rep.is_a?(Representative) }).to be_truthy
end

And('each created Representative should have the correct name, ocdid, and title') do
  # Implement assertions to check the attributes of each created Representative
  @created_reps.each do |rep|
    expect(rep.name).not_to be_nil
    expect(rep.ocdid).not_to be_nil
    expect(rep.title).not_to be_nil
    # Add additional assertions if needed to validate the correctness of attributes
  end
end
