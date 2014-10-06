require 'rails_helper'
require 'support/utilities'


describe "Static pages" do
  let(:base_title) { "Ruby on Rails Tutorial Sample App"}

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_content(heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    let(:user) { FactoryGirl.create(:user)}
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title("| Home")}

    describe "for signed_in users" do
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
        #puts user.feed.count
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          #puts page.body
          expect(page).to have_selector("li", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end

    describe "microposts pagination" do
      before(:all) do
        @user = FactoryGirl.create(:user)
        50.times { |n| FactoryGirl.create(:micropost,
                              user: @user, content: "test_#{n}") }
        end

      describe "should correct" do
        before do
          sign_in @user
          visit root_path
        end
        it { should have_selector('div.pagination') }
        it "should list each microposts" do
          Micropost.paginate(page: 1).each do |micropost|
            expect(page).to have_selector('li', text: micropost.content)
          end
        end
      end
    end

    describe "should show correct microposts number on side" do

      describe "for more than one microposts" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          sign_in user
          visit root_path
        end

        it { should have_content("2 microposts") }
      end

      describe "for zero microposts" do
        before do
          sign_in user
          visit root_path
        end
        it { should have_content("0 microposts")}
      end

    end


  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading) { 'About' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title('Sign up')
    click_link "sample app"
    expect(page).to have_title(full_title(''))

  end

end