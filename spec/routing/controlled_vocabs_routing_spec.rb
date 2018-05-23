require "rails_helper"

RSpec.describe ControlledVocabsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/controlled_vocabs").to route_to("controlled_vocabs#index")
    end

    it "routes to #new" do
      expect(:get => "/controlled_vocabs/new").to route_to("controlled_vocabs#new")
    end

    it "routes to #show" do
      expect(:get => "/controlled_vocabs/1").to route_to("controlled_vocabs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/controlled_vocabs/1/edit").to route_to("controlled_vocabs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/controlled_vocabs").to route_to("controlled_vocabs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/controlled_vocabs/1").to route_to("controlled_vocabs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/controlled_vocabs/1").to route_to("controlled_vocabs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/controlled_vocabs/1").to route_to("controlled_vocabs#destroy", :id => "1")
    end

  end
end
