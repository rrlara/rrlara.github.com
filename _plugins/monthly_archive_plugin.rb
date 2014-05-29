# Jekyll Module to create monthly archive pages
#
# Shigeya Suzuki, November 2013
# Copyright notice (MIT License) attached at the end of this file
#

#
# This code is based on the following works:
#   https://gist.github.com/ilkka/707909
#   https://gist.github.com/ilkka/707020
#   https://gist.github.com/nlindley/6409459
#

#
# Archive will be written as #{archive_path}/#{year}/#{month}/index.html
# archive_path can be configured in 'path' key in 'monthly_archive' of
# site configuration file. 'path' is default null.
#

module Jekyll

  # Generator class invoked from Jekyll
  class MonthlyArchiveGenerator < Generator
    def generate(site)
      posts_group_by_year_and_month(site).each do |ym, list|
        site.pages << MonthlyArchivePage.new(site, archive_base(site),
                                             ym[0], ym[1], list)
      end
    end

    def posts_group_by_year_and_month(site)
      site.posts.each.group_by { |post| [post.date.year, post.date.month] }
    end

    def archive_base(site)
      site.config['monthly_archive'] && site.config['monthly_archive']['path'] || ''
    end
  end

  # Actual page instances
  class MonthlyArchivePage < Page

    ATTRIBUTES_FOR_LIQUID = %w[
      year,
      month,
      date,
      content
    ]

    def initialize(site, dir, year, month, posts)
      @site = site
      @dir = dir
      @year = year
      @month = month
      @archive_dir_name = '%04d/%02d' % [year, month]
      @date = Date.new(@year, @month)
      @layout =  site.config['monthly_archive'] && site.config['monthly_archive']['layout'] || 'monthly_archive'
      self.ext = '.html'
      self.basename = 'index'
      self.content = <<-EOS

{% for post in page.posts reversed %}
<div class='listing col7 margin15 pad4h'>

    {% if date != ndate %}
      <h3 id="{{post.date | date: '%B %Y'}}" class='month'></h3>
    {% endif %}
    <div id="{{post.title}}" class="article clearfix">
        <div class='date'>
          <span>{{post.date | date:"%B %d"}}</span>
        </div>
        <span class="byContainer">by</span>
        {% if post.members %}
          {% for member in site.data.members %}
            {% if member.name == {{post.members}} %}
            <img class="memberThumbnail" width="30px" height="30px" src='{{site.baseurl}}/img/members/{{member.pic}}' alt='' />
            {% endif %}
          {% endfor %}
        <strong>{{post.members}}</strong>
        {% else %}
          <img class="memberThumbnail" width="30px" height="30px" src='{{site.baseurl}}/img/gear.png' alt='' />
          <strong>SpatilDev</strong>
        {% endif %}
        <a class='item' href='{{site.baseurl}}{{item.url}}'>{{post.title  | upcase}}
        </a>

        {% if post.youtube_url %}
        {% capture youtubeurl %}{{post.youtube_url}}{% endcapture %}
            <div class="video-wrapper">
              <iframe width="100%" height="100%"
              src="//www.youtube.com/embed/{{youtubeurl}}"
              frameborder="0" allowfullscreen></iframe>
              <p><a href="//www.youtube.com/embed/{{youtubeurl}}">Full Screen</a>
            </div>
        {% endif %}

        {% if post.vimeo_url %}
        {% capture vimeourl %}{{post.vimeo_url}}{% endcapture %}
        <div class="video-wrapper">
            <iframe src="//player.vimeo.com/video/{{vimeourl}}" width="100%" height="100%" frameborder="0"
            webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
            <p><a href="//player.vimeo.com/video/{{vimeourl}}">Full Screen</a>
            </div>
        {% endif %}

        {% if post.splash %}
          {% if post.splash contains 'http' %}
            {% capture url %}{{post.splash}}{% endcapture %}
          {% else %}
            {% capture url %}{{site.baseurl}}{{post.splash}}/{% endcapture %}
          {% endif %}

          <div class='splash'>
            <a href="{{site.baseurl}}{{post.url}}"><img width="100%" src='{{url}}' alt='' /></a>
          </div>

        {% endif %}

        {% if post.summary %}
        <div class="summeryText" >{{ post.summary }}<a href="{{site.baseurl}}{{post.url}}"><br><span>read more</span><a></div>
        {% endif %}

        {% if post.tags != empty %}
          {% for post in post.tags %}
          <a class="label label-info" href="{{site.baseurl}}/tags/{{ post }}"><i class="fa fa-tags"></i>  {{ post }}</span></a>
          {% endfor %}
        {% endif %}
</div>
</div>
{% endfor %}




      EOS
      self.data = {
          'layout' => @layout,
          'type' => 'archive',
          'title' => "Monthly archive for #{@year}/#{@month}",
          'posts' => posts
      }
    end

    def render(layouts, site_payload)
      payload = {
          'page' => self.to_liquid,
          'paginator' => pager.to_liquid
      }.deep_merge(site_payload)
      do_layout(payload, layouts)
    end

    def to_liquid(attr = nil)
      self.data.deep_merge({
                               'content' => self.content,
                               'date' => @date,
                               'month' => @month,
                               'year' => @year
                           })
    end

    def destination(dest)
      File.join('/', dest, @dir, @archive_dir_name, 'index.html')
    end

  end
end

# The MIT License (MIT)
#
# Copyright (c) 2013 Shigeya Suzuki
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
