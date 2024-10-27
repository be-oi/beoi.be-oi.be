
###
# Contest-related states
###
set :beoi_year, 2025

# states:
# - :preregistration -- Calendar on :beoi_year ready, but registrations not yet open
# - :registration -- Registrations (both form and platform) open
# - :waiting_qualif_results -- Qualif past, waiting for results to be available
# - :qualif_results_published -- Qualif results available, final in future
# - :waiting_final_results -- Final past, waiting for results to be available
# - :final_results_published -- Final results available
set :contest_state, :registration
set :becp_results_available, false

# some config depending on the contest state
set :show_qualif_results, %i[qualif_results_published waiting_final_results final_results_published].include?(config.contest_state)
set :final_is_over, %i[waiting_final_results final_results_published].include?(config.contest_state)
set :show_final_results, config.contest_state == :final_results_published
set :registration_open, config.contest_state == :registration

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

activate :i18n, :mount_at_root => false
activate :directory_indexes

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
helpers do
  def page_header_empty_image_holder
    '<div class="background-image-holder" id="page-header-image-holder"><img src="data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=" width="0" height="0" alt="" /></div>'
  end

  def ext_link_to(name, href, **params)
    link_to(name, href, params.merge({"target"=>"_blank"}))
  end

  # convert a list of scores (one per line) as a string to a list that can be used the JS lib for drawing charts
  def score_list_to_js_chart(scores, threshold)
    scores.lines.map(&:chomp).map do |score|
      if score.to_i >= threshold
        "[' ',0,#{score}]"
      else
        "[' ',#{score},0]"
      end
    end.join(",")
  end

  def has_current_year_solutions
    data.task_descriptions.has_key? config.beoi_year
  end

  # return the number of scores above or equals to the threshold
  def count_finalists(scores, threshold)
    scores.lines.map(&:chomp).count { |s| s.to_i >= threshold }
  end

  def results
    data[current_page.data.result_file]
  end

end

set :markdown_engine
set :markdown, :fenced_code_blocks => true, :smartypants => true

set :css_dir, 'css'

set :js_dir, 'js'

set :images_dir, 'img'

# file reloaded when css partial changed
# set :bundle_file_css, 'css/all.css'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash, :exts => %w(.mp4 .webm .jpg .jpeg .png .gif .webp .js .css .otf .woff .woff2 .eot .ttf .svg .svgz .map)

  # Use relative URLs
  activate :relative_assets

  # activate :asset_host
  # set :asset_host do
  #   '//YOURDOMAIN.cloudfront.net'
  # end

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :s3_sync do |s3_sync|
  s3_sync.region                     = ENV["AWS_DEFAULT_REGION"]
  s3_sync.delete                     = true # delete stray files
  s3_sync.after_build                = false # do not chain after the build step
end

caching_policy 'text/html; charset=utf-8',                            max_age: 10,       public: true
caching_policy 'text/html',                                           max_age: 10,       public: true
caching_policy 'image/png',                                           max_age: 31536000, public: true
caching_policy 'image/jpeg',                                          max_age: 31536000, public: true
caching_policy 'image/gif',                                           max_age: 31536000, public: true
caching_policy 'image/svg+xml',                                       max_age: 31536000, public: true
caching_policy 'text/css',                                            max_age: 31536000, public: true
caching_policy 'application/javascript',                              max_age: 31536000, public: true
caching_policy 'application/vnd.ms-fontobject',                       max_age: 31536000, public: true
caching_policy 'application/font-woff',                               max_age: 31536000, public: true
caching_policy 'application/font-woff2',                              max_age: 31536000, public: true
caching_policy 'application/vnd.oasis.opendocument.formula-template', max_age: 31536000, public: true
default_caching_policy                                                max_age: 60
