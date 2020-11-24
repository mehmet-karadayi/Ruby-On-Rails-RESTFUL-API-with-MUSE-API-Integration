require 'json'

class Api::V1::ListingsController < ApplicationController

  # GET /listings
  def index
    @listings = Listing.all
    render json: @listings
  end

  # GET /listings/:id
  def show
    @listing = Listing.find(params[:id])
    render json: @listing
  end

  # POST /listings
  def create
    @listing = Listing.new(listing_params)
    if @listing.save
      render json: @listing
    else
      render eroor: { error: 'Unable to create Listing.'}, status: 400
    end
  end

  # PUT /listings/:id
  def update
    @listing = Listing.find(params[:id])
    if @listing
      @listing.update(listing_params)
      render json:{ message: 'Listing successfully updated.' }, status: 200
    else
      render json: { error: 'Unable to update Listing.' }, status: 400
    end

    # DELETE /listings/:id
    def destroy 
      @listing = Listing.find(params[:id])
      if @listing 
        @listing.destroy
        render json: { message: 'Listing successfully deleted.'}, status: 200
      else
        render json: { error: 'Unable to delete Listing.' }, status: 400
      end
    end

    private 

    def listing_params
      params.permit(:job_title, :company, :location, :summary, :url)
    end

  end











end
