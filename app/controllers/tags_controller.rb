class TagsController < ApplicationController
  include TagsHelper
  before_filter :require_login, only: [:destroy, :edit]

  def show
    @tag = Tag.find(params[:id])
  end

  def index
    @tags = Tag.all
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    
    flash.notice = %(Tag "#{@tag.name}" Deleted!)

    redirect_to tags_path
  end

# I did a bunch of work and added in the capability to edit tag names,
# a) because I wanted the practice, and b) because I mistype stuff a 
# lot and if I ran a blog, I'd probably want this feature. The `test_tag`
# logic is to avoid the bug where you could rename a tag with an existing
# tag name. Now you can't (but you can "rename" it to its own name, i.e.
# not make any changes if you hit edit & change your mind)
  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])

    test_tag = Tag.new(tag_params)
    if Tag.find_by(name: test_tag.name).nil? || test_tag.name == @tag.name
      @tag.update(tag_params)

      redirect_to tags_path
    else
      flash.notice = %(Error! Tag name "#{test_tag.name}" already exists!)

      redirect_to edit_tag_path(@tag)
    end
  end
end
