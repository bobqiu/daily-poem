namespace :vendor do
  task :copy do
    sh "cp -r node_modules/framework7/dist/img/*.svg src/img/"
  end
end
