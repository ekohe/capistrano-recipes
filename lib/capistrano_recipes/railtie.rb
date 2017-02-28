class CapistranoRecipes::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/recipes.rake'
  end
end
