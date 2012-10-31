# GryphonSitemap

Adds a very simple sitemap generator for well-behaved classes.

[![Build Status](https://secure.travis-ci.org/skandragon/gryphon_sitemap.png?branch=master)](http://travis-ci.org/skandragon/gryphon_sitemap)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/skandragon/gryphon_sitemap)

Generate Rails sitemaps and sitemap indexes for well-behaved models quickly and mostly painlessly.  In this context, a "sitemap" is what a search engine uses to find content on your site, and is required for "hidden" content.  For example, if you have a search field, indexing won't reach past that.  You could use GryphonSitemap to provide direct links to each item that could be returned in a search.

GryphonSitemap generates a sitemap index (usually at /sitemap.xml) which contains pointers to all the other sitemaps for the static and dynamic content.

In the default index, no last-modified times are provided.  In each sitemap page for actual items, the updated_at value is used to provide the timestamp, and a standard link is made for each item.

## Installation

Add this line to your application's Gemfile:

    gem 'gryphon_sitemap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gryphon_sitemap
    
## Usage

In your models:

    has_sitemap

By default, 5,000 items are included in each page.
You may choose to change this if this puts too much load on your server,
or you just wish to have more pages with less on each.  You may customize
this with:

    has_sitemap :per_page => 50

To minimize database load, only :id and :updated_at are retrieved.
In some cases, these are not sufficient when a custom to_param method
is used.  In these cases, you may add additional fields to fetch for
each item:

    has_sitemap :fields => [ :first_name, :last_name ]

This would be useful for a to_param such as:

```ruby
def to_param
  "#{id}-#{first_name.downcase.parameterize}-#{last_name.downcase.parameterize}"
end
```

### Routing

You must add a route manually.  For the sample SitemapController shown below, you
would use:

    resources :sitemap

### Controller

Currently, a fair bit of code is required in a controller you must provide.
Here is an example which handles some static content (see below for the XML used),
two models with custom XML templates (see below), and several "automatic" models.

The hash key, if dynamic, should map to a class name:  "sony_characters" would
be "SonyCharacter", etc.  There is currently no way to override the automatic
class name discovery.

The method indexed_pages returns a hash with keys being page names.  The
configuration of number of pages can be set, which is common for static templates,
or marked as dynamic.  If it is dynamic, the page count provided is ignored, and
each time the sitemap index is retrieved, the model is counted.

```ruby
class SitemapController < ApplicationController
  include GryphonSitemap::SitemapController

  respond_to :xml
  
  def static
    render :static
  end

  def classes
    @classes = Character::ADVENTURE_CLASS_NAMES
  end

  def zones
    @items = Zone.all
  end

  private
  
  def indexed_pages
    {
      static: { pages: 1 },
      classes: { pages: 1 },
      zones: { pages: 1 },
      sony_characters: { dynamic: true },
      sony_guilds: { dynamic: true },
      sony_items: { dynamic: true }
    }
  end
end
```

A static template could look like:

```ruby
xml.instruct!
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  xml.url do
    xml.loc root_url
    xml.changefreq 'daily'
  end
  
  for url in [ changelog_about_index_url, contact_about_index_url, developer_about_index_url ]
    xml.url do
      xml.loc url
      xml.changefreq 'weekly'
    end
  end
end
```

The custom template for Zones just uses a different URL:

```ruby
xml.instruct!
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  #
  # Zone Mobs
  #
  for item in @items
    xml.url do
      xml.loc zone_mobs_url(item)
      xml.lastmod item.updated_at.to_s(:w3c)
    end
  end
end
```

And the one for "classes" is just iterating through fixed values:

```ruby
xml.instruct!
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  #
  # adventure class main index page
  #
  xml.url do
    xml.loc adventure_classes_url
  end

  #
  # spells for classes
  #
  @classes.each do |adventure_class_name|
    xml.url do
      xml.loc adventure_class_spells_url(adventure_class_name)
    end
  end
end
```

### Error Pages

It is important to provide a good error page which returns status
404 for items that do not exist.  The default behavior of Model.find
will return a server error (500) if the record is not found.

I use this in my controllers, coupled with a pleasing to the end user
(who will see the page if they follow a link) error page:

```ruby
def show
  @user = User.where(:id => params[:id].to_i).first
  if @user.blank?
    render "not_found", :status => 404
    return
  end
end
```

### robots.txt

You will want to add some content to your robots.txt to allow for automatic sitemap
discovery.

```text
User-Agent: *
Disallow: /auth
Sitemap: http://eq2mission.flame.org/sitemap.xml
```

## Authors

Michael Graff
[twitter](https://twitter.com/skandragon)
[github](https://github.com/skandragon)
