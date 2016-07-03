require 'rails_helper'

RSpec.describe ShortyController, type: :controller do

  describe "POST #create" do

    before(:all) do
      @valid_shortcode_params = {url: "http://www.google.com", shortcode: "google"}
      @invalid_shortcode_params = {url: "http://www.google.com", shortcode: "go#ogl$e"}
      @invalid_url_params = {shortcode: "google"}
    end

    context "without url param" do
      it "returns 400 code" do
        post :create, @invalid_url_params
        response.status.should eq(400)
      end
    end

    context "with valid shortcode param" do
      it "saves the new contact in the database" do
        expect{
          post :create, @valid_shortcode_params
        }.to change(Shortcode,:count).by(1)
      end
      it "returns 200 code" do
        post :create, @valid_shortcode_params
        response.status.should eq(200)
      end
      it "returns JSON with the shortcode" do
        post :create, @valid_shortcode_params
        JSON.parse(response.body).should eq({ "shortcode" => @valid_shortcode_params[:shortcode]})
      end
    end

    context "with invalid shortcode param" do
      it "does not save the new contact in the database if the shortcode does not match the regex" do
        expect{
          post :create, @invalid_shortcode_params
        }.to change(Shortcode,:count).by(0)
      end
      it "returns 422 code when the shortcode param does not match the regex" do
        post :create, @invalid_shortcode_params
        response.status.should eq(422)
      end
      it "returns JSON with error message for the regex match" do
        post :create, @invalid_shortcode_params
        JSON.parse(response.body).should eq({ "error" => "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$."})
      end
    end

    context "with duplicate shortcode param" do
      it "does not save the new contact in the database if the shortcode exists" do
        post :create, @valid_shortcode_params
        expect{
          post :create, @valid_shortcode_params
        }.to change(Shortcode,:count).by(0)
      end
      it "returns 409 code when the shortcode param exists" do
        post :create, @valid_shortcode_params
        post :create, @valid_shortcode_params
        response.status.should eq(409)
      end
      it "returns JSON with error message for the duplicate shortcode" do
        post :create, @valid_shortcode_params
        post :create, @valid_shortcode_params
        JSON.parse(response.body).should eq({ "error" => "The the desired shortcode is already in use. Shortcodes are case-sensitive."})
      end
    end
  end

  describe "GET #redirect" do

    context "shortcode param exists in the system"  do
      before(:each) do
        @shortcode = FactoryGirl.create(:shortcode, url: "http://www.example.com", shortcode: "example")
      end

      it "redirects to shortcode url if shortcode exists" do
        get :redirect, shortcode: "example"
        expect(response).to redirect_to %r(\A#{@shortcode.url})
      end

      it "returns 302" do
        get :redirect, shortcode: "example"
        response.status.should eq(302)
      end
    end

    context "shortcode param does not exist"  do
      it "returns 404" do
        get :redirect, shortcode: "nonexistant"
        response.status.should eq(404)
      end
    end

  end

  describe "GET #stats" do

    before(:each) do
      @shortcode = FactoryGirl.create(:shortcode, url: "http://www.example.com", shortcode: "example")
    end

    context "shortcode param exists in the system"  do
      it "returns shortcode stats if shortcode exists" do
        get :stats, shortcode: "example"
        JSON.parse(response.body).should eq({
                                                     "startDate" => @shortcode.created_at.to_formatted_s(:iso8601),
                                                     "lastSeenDate" => @shortcode.updated_at.to_formatted_s(:iso8601),
                                                     "redirectCount" => @shortcode.hits
                                                 })
      end

      it "returns 200" do
        get :stats, shortcode: "example"
        response.status.should eq(200)
      end
    end

    context "shortcode param does not exist"  do
      it "returns 404" do
        get :stats, shortcode: "nonexistant"
        response.status.should eq(404)
      end
    end
  end
end
