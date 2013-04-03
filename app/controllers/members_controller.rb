class MembersController < ApplicationController
  # GET /members
  # GET /members.json
  def index
    if !checklogin? then return end
    @members = Member.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @members }
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    if !checklogin? then return end
    @me = me?
    @member = Member.find(params[:id])

    frs = Friend.where(:member_id => params[:id].to_i)
    frlist = '('
    frs.each do |fr|
      frlist += fr.friend_id.to_s + "+"
    end
    frlist += '0)'
    query = "select * from members where id in " + frlist
    @friends = Member.find_by_sql(query)

    frs = Friend.where(:friend_id => params[:id].to_i)
    frlist = '('
    frs.each do |fr|
      frlist += fr.member_id.to_s + "+"
    end
    frlist += '0)'
    query = "select * from members where id in " + frlist
    @friended = Member.find_by_sql(query)

    @isFr = Friend.where(:member_id => session[:login].id, :friend_id => params[:id].to_i).count > 0
    @isFr = Friend.where(:friend_id => session[:login].id, :member_id => params[:id].to_i).count > 0

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/new
  # GET /members/new.json
  def new
    if !checklogin? then return end
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/1/edit
  def edit
    if !checklogin? then return end
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.json
  def create
    if !checklogin? then return end
    @member = Member.new(params[:member])

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render json: @member, status: :created, location: @member }
      else
        format.html { render action: "new" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    if !checklogin? then return end
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    if !checklogin? then return end
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to members_url }
      format.json { head :no_content }
    end
  end

  def login
    @msg = "get"
    @member = Member.new
    if request.post? then
      @member = Member.new(params[:member])
      record = Member.find_by_user(params[:member][:user])
      if record == nil then
	@msg = "record is nil"
	@member.errors.add('user',"not registrated!")
      else
	if record.pass != params[:member][:pass] then
	  @msg = "password is wrong."
	  @member.errors.add('pass','password is wrong!')
	else
	  @msg = "good!"
	  @member = record
	  session[:login] = record
	  redirect_to '/members/' + record_id.to_s
	end
      end
    end
  end

  def friend
    if Friend.where(:member_id => session[:login].id, :friend_id => params[:id].to_i).exist? then
      Friend.where(:member_id => session[:login].id, :friend_id => params[:id].to_i).each do |f|
	f.destroy
      end
    else
      Friend.new(:member_id => session[:login].id, :friend_id => params[:id].to_i).save
    end
    redirect_to :action => 'show', :id => session[:login].id
  end
end
