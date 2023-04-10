class Like2sController < ApplicationController

    def create
        like2 = current_user.like2s.create(external_site_id: params[:external_site_id])
        redirect_back(fallback_location: root_path)
    end
    
    def destroy
        like2 = Like2.find_by(external_site_id: params[:external_site_id], user_id: current_user.id)
        # binding.pry
        like2.destroy
        redirect_back(fallback_location: root_path)
    end

end
