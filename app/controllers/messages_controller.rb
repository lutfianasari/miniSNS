class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index
    if !checklogin? then return end
    page_length = 10 #number of items in a page
    @page = params.has_key?(:page) ? params[:page].to_i : 1

    friends = Friend.where(:member_id => session[:login].id)
    frlist = '('
    friends.each do |fr|
      frlist += fr.friend_id.to_s + ","
    end
    frlist += session[:login].id_to_s + ')'
    query = "select count(*) from messages where member_id in " + frlist
    #query = "select * from messages where member_id in " + frlist
    msg_num = Message.count_by_sql(query)
    @max_page = msg_num / page_length
    @max_page += msg_num % page_length == 0 ? 0 : 1
    @page = (@page > @max_page) ? @max_page : @page
    @query = "select * from messages where member_id in " + frlist + " order by id desc limit " + page_length.to_s + " offset " + ((@page - 1) * page_length).to_s
    @messages = Message.find_by_sql(@query)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    if !checklogin? then return end
    @message = Message.find(params[:id])
    @isme = me? @message
    @comment = Comment.new({:message_id => params[:id], :member_id => session[:login].id})

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    if !checklogin? then return end
    @message = Message.new(:member_id => session[:login].id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
    if !checkme? @message then return end
  end

  # POST /messages
  # POST /messages.json
  def create
    if !checklogin? then return end
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])
    if !checkme? @message then return end

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    if !checkme? @message then return end
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  def comment
    if request.post? then
      cmt = Comment.new(params[:comment])
      if cmt.save then
	redirect_to "/messages/" + cmt.message_id.to_s
      return
      end
    end
  end

end
