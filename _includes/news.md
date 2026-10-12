{%- assign today = site.time | date: "%Y-%m-%d" -%}
{%- assign announcements = site.data.news | sort: "date" | reverse -%}
{%- capture active_news -%}
{%- for item in announcements -%}
  {%- assign published_on = item.date | date: "%Y-%m-%d" -%}
  {%- assign expires_on = item.expires | date: "%Y-%m-%d" -%}
  {%- if published_on <= today and today < expires_on -%}
    {%- assign announcement = item.text | markdownify | strip -%}
<li><strong>{{ item.date | date: "%B %-d, %Y" }}:</strong> {{ announcement | remove: '<p>' | remove: '</p>' }}</li>
  {%- endif -%}
{%- endfor -%}
{%- endcapture -%}
{% if active_news != empty %}
<h2 id="news">News</h2>
<ul>{{ active_news }}</ul>
{% endif %}
