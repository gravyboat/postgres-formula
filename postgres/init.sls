{% from "postgres/map.jinja" import postgres with context %}

postgresql:
  pkg:
    - installed
    - name: {{ postgres.pkg }}
  service:
    - running
    - enable: true
    - name: {{ postgres.service }}
    - require:
      - pkg: {{ postgres.pkg }}

{% if 'db' in pillar['postgres'] %}
postgres-app-user:
  postgres_user:
    - present
    - name: {{ salt['pillar.get']('postgres:lookup:db:user' }}
    - createdb: {{ pillar['postgres']['db']['createdb'] }}
    - password: {{ pillar['postgres']['db']['password'] }}
    - runas: postgres
    - require:
      - service: {{ postgres.service }}

postgres-app-db:
  postgres_database:
    - present
    - name: {{ pillar['postgres']['db']['name'] }}
    - encoding: UTF8
    - lc_ctype: en_US.UTF8
    - lc_collate: en_US.UTF8
    - template: template0
    - owner: {{ pillar['postgres']['db']['user'] }}
    - runas: postgres
    - require:
        - postgres_user: postgres-app-user
{% endif %}
