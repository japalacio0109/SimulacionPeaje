class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def validation
    if form_params[:hini] >= form_params[:hfini]
      flash[:danger] = "Error en el ingreso de fechas"
      redirect_to index_url
    end

    if form_params[:med_llegada].to_i < 0 or form_params[:med_llegada].to_i < 0
      flash[:danger] = "Error en el ingreso de las medias de caseta general y/o especial"
      redirect_to index_url
    end
  end
end
