require 'spec_helper'
require 'rest-client'

describe "comment api", type: :feature, js: true, driver: :selenium do

  it "renders video" do
    visit "/"
    using_wait_time 4 do
      expect(page.body.length > 1).to eq(true)
    end
  end
end