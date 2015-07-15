---
layout: parceiros
title: Parceiros
permalink: "/parceiros/"
---


{% for parceiro in site.data.parceiros %}
  <p>Cidade de {{ parceiro.cidade }}{% if parceiro.area %}, área de {{ parceiro.area }}{% endif %}</p>

  {% for pessoa in parceiro.pessoas %}

  <h3>{{ pessoa.nome }}</h3>
  <p>Em {{ pessoa.ano }}</p>
  <ul>
  {% for ativ in pessoa.atividades %}
    <li>{{ ativ.sistema }} ({{ ativ.linguagem }})</li>
  {% endfor %}
  </ul>

  {% endfor %}

{% endfor %}