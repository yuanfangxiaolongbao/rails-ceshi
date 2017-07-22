class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit,]
  before_action :papapa, only: [:edit, :update, :destroy]
  def index
    @groups = Group.all
  end

  def new
    @group =Group.new
  end

  def show
    @group =Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
    papapa
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
      if @group.save
      redirect_to groups_path
    else
      render :new
   end
  end

  def update
    papapa
      if @group.update(group_params)
        redirect_to groups_path, notice: "更新成功"
      else
        render :edit
    end
  end

  def destroy
     papapa
    @group.destroy
    flash[:notice] = "删除成功"
    redirect_to groups_path
  end

  def join
    @group = Group.find(params[:id])
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] =" 成功加入"
    else
      flash[:warning] ="你已经是本群成员"
    end
  end

  def quit
    @group =Group.find(params[:id])
    if current_user.quit!(@group)
      flash[:alert]="已退出"
    else
      flash[:warning]="你不是这里成员怎么退出？"
    end

  redirect_to group_path(@group)
end


  private

  def papapa
    @group =Group.find(params[:id])
    if current_user!=@group.user
      redirect_to root_path, alert:"滚粗"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
