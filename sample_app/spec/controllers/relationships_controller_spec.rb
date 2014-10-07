require 'spec_helper'
describe RelationshipsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  before do
    sign_in user, no_capybara: true
  end

end