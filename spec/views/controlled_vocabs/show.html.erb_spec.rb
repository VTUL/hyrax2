require 'rails_helper'

RSpec.describe "controlled_vocabs/show", type: :view do
  before(:each) do
    @controlled_vocab = assign(:controlled_vocab, ControlledVocab.create!(
      :field => "Field",
      :name => "Name",
      :image_filename => "Image Filename"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Field/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Image Filename/)
  end
end
