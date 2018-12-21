class CoursesController < ApplicationController

  before_action :student_logged_in, only: [:select, :quit, :list]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :destroy, :update, :open, :close]#add open by qiao
  before_action :logged_in, only: :index

  #-------------------------for teachers----------------------

  def new
    @course=Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      current_user.teaching_courses<<@course
      redirect_to courses_path, flash: {success: "新课程申请成功"}
    else
      flash[:warning] = "信息填写有误,请重试"
      render 'new'
    end
  end

  def edit
    @course=Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    if @course.update_attributes(course_params)
      flash={:info => "更新成功"}
    else
      flash={:warning => "更新失败"}
    end
    redirect_to courses_path, flash: flash
  end

  def open
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: true)
    redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
  end

  def close
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: false)
    redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
  end

  def destroy
    @course=Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash={:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  #-------------------------for students----------------------

  def list
    @courses = Course.where(:open=>true).paginate(page: params[:page], per_page: 4)
    if !params[:key].nil? && params[:key] != "全部"
      @coursesFilt = Course.where("name like ? and open = true","%#{params[:key]}%").paginate(page: params[:page], per_page: 4)
      @course = @coursesFilt-current_user.courses
         # render json: @courses, location: list_courses_url(@course), flash: flash 
       else
        @course = @courses-current_user.courses
      end

      if @course.size > 0
        flash={:info => "查询到"+@course.size.to_s+"条数据"}
      else
        flash={:warning => "未查询到相关课程"}
      end
      
    # @course = @courses-current_user.courses
    tmp=[]
    @course.each do |course|
      if course.open==true
        tmp<<course
      end
    end
    @course=tmp
    render location: list_courses_url(@course), flash: flash     
    # render json: @course, location: list_courses_url(@course), flash: flash 
  end



  def list #wsy
    @courses = Course.where(:open=>true).paginate(page: params[:page], per_page: 8) 
    if current_user.nil?
      @course = @courses
    else
      @course = @courses - current_user.courses
    end
    tmp=[]
    @course.each do |course|
      if course.open==true
        tmp<<course
      end
    end
    @course=tmp
    

    # @grade=Grade.where(:course_id => params[:id],:user_id=>current_user.id).first

    @all_statuses = [["所有", "所有"],["一级学科核心课", "一级学科核心课"],["专业核心课", "专业核心课"], ["专业研讨课", "专业研讨课"],["专业普及课", "专业普及课"],["公共选修课", "公共选修课"]]
    @tmp_status = params[:status]
    @selectcourse = params[:search]
    if !@selectcourse.blank?

      if @tmp_status != "所有"
        if current_user.nil?
          @course = @courses
        else
         @course = Course.where("name LIKE '%#{@selectcourse}%' ").all - current_user.courses
       end
       tmp=[]
       @course.each do |course|
         if course.open==true && course.course_type == @tmp_status
          tmp<<course
        end
      end
      @course=tmp
    else

      if current_user.nil?
        @course = @courses
      else
       @course = Course.where("name LIKE '%#{@selectcourse}%' ").all - current_user.courses
     end
     tmp=[]
     @course.each do |course|
       if course.open==true
         tmp<<course
       end
     end
     @course=tmp
   end
 else

  if @tmp_status.nil? or @tmp_status == "" or @tmp_status == "所有"
    if current_user.nil?
      @course = @courses
    else
      @course = @courses - current_user.courses
    end
    tmp=[]
    @course.each do |course|
      if course.open==true
        tmp<<course
      end
    end
    @course=tmp
    
  elsif
   @tmp_status != "所有"
   tmp=[]
   @course.each do |course|
    if course.open==true && course.course_type == @tmp_status
      tmp<<course
    end
  end
  @course=tmp


end
end
end


# def select
#   @course=Course.find_by_id(params[:id])
#   current_user.courses<<@course
#   flash={:suceess => "成功选择课程: #{@course.name}"}
#   redirect_to courses_path, flash: flash
# end

 def select        #wsy
    @course=Course.find_by_id(params[:id])  
    
    tmp=[]
    if current_user.nil?
      tmp=['周三(2-4)','周二(3-5)','周三(9-11)']
    else
    @alltime = current_user.courses

    @alltime.each do |alltime|
        tmp<<alltime.course_time
    end
    end
    k = 0 
    for i in 0..tmp.size-1 do  
      if @course.course_time[0..1] == tmp[i][0..1]
          a = @course.course_time[3].to_i 
          if @course.course_time.size == 7 
              b =  @course.course_time[5].to_i
          else 
              b =  @course.course_time[5..6].to_i
          end
          c = tmp[i][3].to_i 
          if tmp[i].size == 7 
              d =  tmp[i][5].to_i
          else 
              d =  tmp[i][5..6].to_i
          end
          if a == c
             k += 1
          elsif a<c && c<=b
             k += 1
          elsif a>c && a<=d
             k += 1
          end    
      end
    end
    if k != 0
        flash={:info => "#{@course.name}  与已选课程时间冲突"}
        redirect_to list_courses_path, flash: flash
    else
    tmp = 0
    tmp = @course.student_num
    tmp += 1  
    @course.update_attributes(student_num: tmp) 
    if current_user.nil?
    else
    current_user.courses<<@course
    @grade=Grade.where(:course_id => params[:id],:user_id=>current_user.id).first
    @grade.update_attributes(degree: 0)
    # @course.update_attributes(test: "否")
    if params[:dc] == "1"
      # @course.update_attributes(test: "是") 
      @grade.update_attributes(degree: 1)        
    end
    end
    flash={:info => "成功选择课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
    end
  end

def quit
  @course=Course.find_by_id(params[:id])
  current_user.courses.delete(@course)
  flash={:success => "成功退选课程: #{@course.name}"}
  redirect_to courses_path, flash: flash
end

def credit #wsy
  @courses=current_user.courses if student_logged_in?

    #计算已选的学分
    selectedCredit=0.0
    @courses.each do |course|
      selectedCredit += course.credit.split('/')[1].to_f
    end

    #计算已经获得的学分
    gotScore = 0.0
    @grades=current_user.grades
    @grades.each do |grade|
      if !grade.grade.nil? && grade.grade >= 60
        gotScore += grade.course.credit.split('/')[1].to_f
      end
    end

    @row = @courses.size
    @scoreNeed = 20
    @scoreGot = gotScore
    @scoreSelect = selectedCredit
  end

# def credit
#   @course=current_user.courses
#     tmp = []
#     @course.each do |course|
#        tmp<<Grade.where(:course_id => course.id,:user_id=>current_user.id).first
#     end 
#     @grade = tmp
# end
  #-------------------------for both teachers and students----------------------

  def index
    @course=current_user.teaching_courses.paginate(page: params[:page], per_page: 4) if teacher_logged_in?
    @course=current_user.courses.paginate(page: params[:page], per_page: 4) if student_logged_in?
  end


  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def course_params
    params.require(:course).permit(:course_code, :name, :course_type, :teaching_type, :exam_type,
     :credit, :limit_num, :class_room, :course_time, :course_week)
  end


end
