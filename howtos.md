---
layout: parceiros
title: How-To
permalink: "/howtos/"
---


<ul>
{% for org_hash in site.data.howtos %}
{% assign org = org_hash[1] %}
  <li>
    <a href="https://">
      {{ org.name }}:
    </a>
    {{ org.tutoriais | size }} How-to(s).
  </li>
{% endfor %}
</ul>