# Base class for interfacing with ActiveResources
#
# @example
#   class window.Order extends ActiveResource::Base
#     this.className = 'Order'
#     this.queryName = 'orders'
#
#     @belongsTo('product')
#
#     @hasMany('comments', as: 'resource')
#
class ActiveResource::Base
  ActiveResource.extend(@, ActiveResource::Associations)
  ActiveResource.extend(@, ActiveResource::Reflection.prototype)
  ActiveResource.extend(@, ActiveResource::Relation.prototype)
  ActiveResource.include(@, ActiveResource::Associations.prototype)
  ActiveResource.include(@, ActiveResource::Attributes)
  ActiveResource.include(@, ActiveResource::Errors)
  ActiveResource.include(@, ActiveResource::Persistence)
  ActiveResource.include(@, ActiveResource::QueryParams.prototype)
  ActiveResource.include(@, ActiveResource::Typing)

  # The name to use when querying the server for this resource
  # @example 'products'
  @queryName = ''

  # The name to use when constantizing on the client
  # @example 'Product'
  #
  # @note On a production server where minification occurs, the actual name of classes
  #   `@constructor.name` will change from `Product` to perhaps `p`. But, since a class
  #   is added as a variable to the ActiveResource.constantizeScope, we can use this
  #   method to determine the name of the variable in the constantizeScope
  #
  # @note ActiveResource will eventually employ an `ActiveResource.buildConstants()` method
  #   to be called after defining all classes, and it will auto-generate @queryName
  #   and @className, but until then you must define these yourself in each class
  @className = ''

  # The primary key by which to index this resource
  @primaryKey = 'id'

  constructor: ->

  # Links to query the server for this model with
  #
  # @return [Object] the URL links used to query this resource type
  @links: ->
    throw 'ActiveResource.baseUrl is not set' unless ActiveResource.baseUrl?
    @__links ||= { related: ActiveResource.baseUrl + @queryName + '/' }

  # Links to query the server for this persisted resource with
  links: ->
    @__links ||= @klass().links()

  # private

  # Creates a new ActiveResource::Relation with the extended queryParams passed in
  #
  # @param [Object] queryParams the extended query params for the relation
  # @return [ActiveResource::Relation] the new Relation for the extended query
  @__newRelation: (queryParams) ->
    new ActiveResource::Relation(this, queryParams)
