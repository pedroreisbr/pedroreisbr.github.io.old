---
layout: post
title:  "Exibindo uma lista de posts"
date: "2015-07-13 13:52:54 America/Araguaina"
permalink: /post/lista/
published: true
categories: post jekyll
tag: post jekyll lista
---

<h3>Lista de posts com um pequeno aperitivo do conteúdo de cada um</h3>

<!--more-->

<ul>
  {% for post in site.posts %}
    <li>
      <h2><a href="{{ post.url }}">{{ post.title }}</a><h2>
      <h6><pre>post.excerpt</pre></h6>
      {{ post.excerpt }}
	
      <h6><pre>post.excerpt | remove: 'tag p' | remove: 'tag p'</pre></h6>
      {{ post.excerpt | remove: '<p>' | remove: '</p>' }}
    </li>
    <hr />
  {% endfor %}
</ul>
