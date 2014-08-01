class ShoppingListsController < ApplicationController
  before_action :set_shopping_list, only: [:show, :edit, :update, :destroy]

  # GET /shopping_lists
  # GET /shopping_lists.json
  def index
    @shopping_lists = ShoppingList.all
  end

  # GET /shopping_lists/1
  # GET /shopping_lists/1.json
  def show
    @shopping_list_object = ShoppingListsProcedure.new(@shopping_list)
  end

  # GET /shopping_lists/new
  def new
    @shopping_list = ShoppingList.new
    2.times { @shopping_list.recipes.build}
  end

  # GET /shopping_lists/1/edit
  def edit
    redirect_to root_path
  end

  # POST /shopping_lists
  # POST /shopping_lists.json
  def create
    modified_params = remove_empty_recipes(shopping_list_params)
    @shopping_list = ShoppingList.new(modified_params)
    respond_to do |format|
      if @shopping_list.save
        format.html { redirect_to @shopping_list, notice: 'Shopping list was successfully created.' }
        format.json { render :show, status: :created, location: @shopping_list }
      else
        format.html { render :new }
        format.json { render json: @shopping_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shopping_lists/1
  # PATCH/PUT /shopping_lists/1.json
  def update

    respond_to do |format|
      if @shopping_list.update(shopping_list_params)
        format.html { redirect_to @shopping_list, notice: 'Shopping list was successfully updated.' }
        format.json { render :show, status: :ok, location: @shopping_list }
      else
        format.html { render :edit }
        format.json { render json: @shopping_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shopping_lists/1
  # DELETE /shopping_lists/1.json
  def destroy
    @shopping_list.destroy
    respond_to do |format|
      format.html { redirect_to shopping_lists_url, notice: 'Shopping list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def remove_empty_recipes hash
    params_hash = hash
    params_hash["recipes_attributes"].each do |k, v|
      params_hash["recipes_attributes"].delete(k) if v["url"].blank?
    end
    params_hash
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_list
      @shopping_list = ShoppingList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shopping_list_params
      params.require(:shopping_list).permit(:title, recipes_attributes: [:id, :url])
    end

end
