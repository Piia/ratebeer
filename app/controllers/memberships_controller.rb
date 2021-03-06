class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all.reject{ |club| current_user.in? club.members }
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create

    #@membership = Membership.new params.require(:membership).permit(:beer_club_id)

    #if @membership.save
    #  current_user.memberships << @membership
    #  redirect_to user_path current_user
    #else
    #  @beer_clubs = BeerClub.all
    #  render :new
    #end

    @membership = Membership.new(membership_params)
    beer_club = BeerClub.find membership_params[:beer_club_id]
    if not current_user.in? beer_club.members and @membership.save
      current_user.memberships << @membership
      @membership.save
      redirect_to beer_club, notice: "#{current_user.username}, welcome to the club!"
    else
      @beer_clubs = BeerClub.all
      render :new
    end

  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    club_name = @membership.beer_club.name
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: "Membership in #{club_name} ended." }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    membership = Membership.find(params[:id])
    membership.update_attribute :confirmed, (not membership.confirmed)

    new_status = membership.confirmed? ? "confirmed" : "denied"

    membership.destroy unless membership.confirmed

    redirect_to :back, notice:"membership status changed to #{new_status}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
