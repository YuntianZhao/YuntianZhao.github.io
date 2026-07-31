<h2 id="blog">Blog</h2>

{% assign blog_posts = site.data.blog.posts | sort: "date" | reverse %}
{% if blog_posts != empty %}
<ol class="paper-list">
  {% for post in blog_posts %}
  <li>
    {% if post.file %}
    <a class="paper-title" href="{{ post.file | relative_url }}">{{ post.title }}</a>
    {% else %}
    <span class="paper-title">{{ post.title }}</span>
    {% endif %}

    {% assign file_extension = post.file | split: "." | last | downcase %}
    <span class="paper-note">
      {% if post.date %}
      <time datetime="{{ post.date | date: '%Y-%m-%d' }}">{{ post.date | date: "%B %-d, %Y" }}</time>
      {% endif %}
      {% if post.file %}
      {% if post.date %}<span aria-hidden="true"> · </span>{% endif %}
      {% if file_extension == "pdf" %}PDF{% elsif file_extension == "md" %}Markdown{% else %}File{% endif %}
      {% endif %}
    </span>
  </li>
  {% endfor %}
</ol>
{% endif %}
