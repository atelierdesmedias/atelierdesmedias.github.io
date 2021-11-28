---
title: Les coworkers
layout: default
permalink: coworkers
---

{% for coworker in site.coworkers %}
  - [{{ coworker.name }}]({% link {{ coworker.path }} %})
{% endfor %}
