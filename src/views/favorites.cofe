class AP.FavoritesView extends BaseView
  render: (next) ->
    Model.getFavorites (poems) =>
      @loadTemplateOnMainPage 'pages/favorites', poems: poems
      next?()
