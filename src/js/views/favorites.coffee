class Poems.Views.Favorites extends BaseView
  render: (next) ->
    Model.getFavorites (poems) =>
      @loadTemplateOnMainPage 'pages/favorites', poems: poems
      next?()
