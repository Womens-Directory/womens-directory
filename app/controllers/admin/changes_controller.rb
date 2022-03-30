class Admin::ChangesController < Admin::BaseController
  def changes
    @pagy, version_objects = pagy(PaperTrail::Version.order('created_at DESC'))
    @versions = version_objects.map &:decorate
  end
end

# pagination(puts the data in database in chucks 'pages' so it doesn't have to access all of
# database all the time, to save user from downloading extra data and save the database from sending you
# don't need)
# changes method: sets up paginator, with change versions of database in order of most recent first ('created_at DESC')
# 'created_at DESC' created at is the time created and order in descending order
# decorate: way to do functionality that relates to a model and view but is more particular than helper
# is the controller for recent changes in the admin panel, controller decorates(adds logic/methods you don't
# want to put other places like model, view, controller) model before it goes to view
