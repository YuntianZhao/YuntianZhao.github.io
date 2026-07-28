<h2 id="working-papers">Working Papers</h2>

{% if site.data.publications.working_papers != empty %}
<ol class="paper-list">
  {% for paper in site.data.publications.working_papers %}
  <li>
    {% if paper.url %}
    <a class="paper-title" href="{{ paper.url }}">{{ paper.title }}</a>
    {% else %}
    <span class="paper-title">{{ paper.title }}</span>
    {% endif %}
    {% if paper.authors %}<span class="paper-authors">{{ paper.authors }}</span>{% endif %}
    {% if paper.note %}<span class="paper-note">{{ paper.note }}</span>{% endif %}
  </li>
  {% endfor %}
</ol>
{% endif %}
<h2 id="publications">Publications</h2>

{% if site.data.publications.publications != empty %}
<ol class="paper-list">
  {% for paper in site.data.publications.publications %}
  <li>
    {% if paper.url %}
    <a class="paper-title" href="{{ paper.url }}">{{ paper.title }}</a>
    {% else %}
    <span class="paper-title">{{ paper.title }}</span>
    {% endif %}
    {% if paper.authors %}<span class="paper-authors">{{ paper.authors }}</span>{% endif %}
    {% if paper.venue %}<span class="paper-venue">{{ paper.venue }}</span>{% endif %}
  </li>
  {% endfor %}
</ol>
{% endif %}
