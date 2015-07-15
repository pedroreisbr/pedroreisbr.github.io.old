---
layout: portfolio
title:  "Primeiro item do portfolio"
date: "2015-07-14 12:37:21 America/Araguaina"
# permalink: /portfolio/1/
published: true
categories: portfolio collections
tag: portfolio primeiro
---


Este é o primeiro item do portfolio.

Conteudo.

{% if page.collection.* %}
	 • SIM
{% else %}
	 • Não
{% endif %}

{{ site.collections.portfolio | listToHtml}}
