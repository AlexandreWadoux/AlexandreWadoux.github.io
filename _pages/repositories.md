---
layout: page
permalink: /repositories/
title: Repositories
description: Selected open-source software and research code repositories.
nav: true
nav_order: 3
---

## GitHub profile

[AlexandreWadoux](https://github.com/AlexandreWadoux){:target="_blank" rel="noopener noreferrer"}

## Selected repositories

<ul class="repo-list">
  {% for repo in site.data.repositories.github_repos %}
    <li>
      <a href="https://github.com/{{ repo }}" target="_blank" rel="noopener noreferrer">
        {{ repo | split: "/" | last }}
      </a>
    </li>
  {% endfor %}
</ul>
