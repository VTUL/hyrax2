require 'rails_helper'

RSpec.describe "controlled_vocabs/new", type: :view do
  before(:each) do
    assign(:controlled_vocab, ControlledVocab.new(
      :field => "MyString",
      :name => "MyString",
      :image_filename => "MyString"
    ))
  end

  it "renders new controlled_vocab form" do
    render

    assert_select "form[action=?][method=?]", controlled_vocabs_path, "post" do

      assert_select "input[name=?]", "controlled_vocab[field]"

      assert_select "input[name=?]", "controlled_vocab[name]"

      assert_select "input[name=?]", "controlled_vocab[image_filename]"
    end
  end
end
