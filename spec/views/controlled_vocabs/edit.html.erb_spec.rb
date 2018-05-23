require 'rails_helper'

RSpec.describe "controlled_vocabs/edit", type: :view do
  before(:each) do
    @controlled_vocab = assign(:controlled_vocab, ControlledVocab.create!(
      :field => "MyString",
      :name => "MyString",
      :image_filename => "MyString"
    ))
  end

  it "renders the edit controlled_vocab form" do
    render

    assert_select "form[action=?][method=?]", controlled_vocab_path(@controlled_vocab), "post" do

      assert_select "input[name=?]", "controlled_vocab[field]"

      assert_select "input[name=?]", "controlled_vocab[name]"

      assert_select "input[name=?]", "controlled_vocab[image_filename]"
    end
  end
end
