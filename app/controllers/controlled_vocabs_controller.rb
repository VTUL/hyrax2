class ControlledVocabsController < ApplicationController
  include Blacklight::Facet  
  load_and_authorize_resource

  helper_method :sort_column, :sort_direction
  before_action :set_field_names
  before_action :set_controlled_vocab, only: [:show, :edit, :update, :destroy]

  # GET /controlled_vocabs
  # GET /controlled_vocabs.json
  def index
    @controlled_vocabs = ControlledVocab.order(sort_column + " " + sort_direction)
  end

  # GET /controlled_vocabs/1
  # GET /controlled_vocabs/1.json
  def show
  end

  # GET /controlled_vocabs/new
  def new
    @controlled_vocab = ControlledVocab.new
  end

  # GET /controlled_vocabs/1/edit
  def edit
  end

  # POST /controlled_vocabs
  # POST /controlled_vocabs.json
  def create
    @controlled_vocab = ControlledVocab.new(controlled_vocab_params)

    respond_to do |format|
      if @controlled_vocab.save
        format.html { redirect_to @controlled_vocab, notice: 'Controlled vocab was successfully created.' }
        format.json { render :show, status: :created, location: @controlled_vocab }
      else
        format.html { render :new }
        format.json { render json: @controlled_vocab.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /controlled_vocabs/1
  # PATCH/PUT /controlled_vocabs/1.json
  def update
    respond_to do |format|
      if @controlled_vocab.update(controlled_vocab_params)
        format.html { redirect_to @controlled_vocab, notice: 'Controlled vocab was successfully updated.' }
        format.json { render :show, status: :ok, location: @controlled_vocab }
      else
        format.html { render :edit }
        format.json { render json: @controlled_vocab.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /controlled_vocabs/1
  # DELETE /controlled_vocabs/1.json
  def destroy
    @controlled_vocab.destroy
    respond_to do |format|
      format.html { redirect_to controlled_vocabs_url, notice: 'Controlled vocab was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_controlled_vocab
      @controlled_vocab = ControlledVocab.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def controlled_vocab_params
      params.require(:controlled_vocab).permit(:field, :name, :image_filename)
    end

    def set_field_names
      @field_names = facet_field_names.map {|name| [name, name.gsub("_sim", "")]}
    end

    def sort_column
      ControlledVocab.column_names.include?(params[:sort]) ? params[:sort] : "field"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
