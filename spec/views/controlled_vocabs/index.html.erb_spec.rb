require 'rails_helper'

RSpec.describe "controlled_vocabs/index", type: :view do
  before(:each) do
    assign(:controlled_vocabs, [
      ControlledVocab.create!(
        :field => "Field",
        :name => "Name",
        :image_filename => "Image Filename"
      ),
      ControlledVocab.create!(
        :field => "Field",
        :name => "Name",
        :image_filename => "Image Filename"
      )
    ])
  end

  it "renders a list of controlled_vocabs" do
    render
    assert_select "tr>td", :text => "Field".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Image Filename".to_s, :count => 2
  end
end
