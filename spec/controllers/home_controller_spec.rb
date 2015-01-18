require 'spec_helper'

describe HomeController, type: :controller do

  it "#index" do
    get :index
    expect(response).to render_template("home/index")
  end
end
